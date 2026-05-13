//
//  RestaurantMenuViewModel.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation
import Combine

enum SortOrder {
    case none, priceAsc, priceDesc
}

class RestaurantMenuViewModel: ObservableObject {
    
    // --- ESTADOS DE DATOS ---
    @Published var restaurantsList: [Restaurant] = []
    @Published var currentMenu: [Product] = []
    private var currentRestaurantId: String = ""
    
    @Published var userProfile: UserProfile? = nil
    
    // --- ESTADOS DEL CARRITO ---
    @Published var cartItems: [CartItem] = []
    
    // Variables calculadas (Equivalente a map y stateIn)
    var cartTotalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var cartTotalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    // --- ESTADOS DE FILTROS Y BÚSQUEDA ---
    @Published var searchQuery: String = ""
    @Published var sortOrder: SortOrder = .none
    @Published var priceRange: ClosedRange<Double> = 0...100000
    @Published var selectedCategory: String = "Todo"
    
    // --- ESTADOS DE UI (MODALES) ---
    @Published var showOrderSuccessModal: Bool = false
    
    // --- LÓGICA REACTIVA (Variables Calculadas en lugar de combine) ---
    var availableCategories: [String] {
        if currentMenu.isEmpty { return ["Todo"] }
        var categories = ["Todo"]
        // Obtenemos categorías únicas y las agregamos
        let unique = Array(Set(currentMenu.map { $0.category })).sorted()
        categories.append(contentsOf: unique)
        return categories
    }
    
    var filteredMenu: [Product] {
        var result = currentMenu.filter { product in
            let matchesText = searchQuery.isEmpty ||
                product.name.localizedCaseInsensitiveContains(searchQuery) ||
                product.description.localizedCaseInsensitiveContains(searchQuery)
            
            let matchesPrice = priceRange.contains(product.price)
            let matchesCategory = selectedCategory == "Todo" || product.category == selectedCategory
            
            return matchesText && matchesPrice && matchesCategory
        }
        
        switch sortOrder {
        case .priceAsc:
            result.sort { $0.price < $1.price }
        case .priceDesc:
            result.sort { $0.price > $1.price }
        case .none:
            break
        }
        
        return result
    }
    
    // --- INICIALIZACIÓN ---
    private let repository: RestaurantRepositoryProtocol
            
    init(repository: RestaurantRepositoryProtocol = FirebaseRestaurantRepository()) {
        self.repository = repository
        
        // 1. Ejecutamos la búsqueda a Firebase apenas nace el ViewModel
        fetchRestaurants()
        
        // 2. Cargamos el perfil local del usuario
        loadUserProfile()
    }
    
    // --- FUNCIONES DE CARGA DE DATOS ---
    private func fetchRestaurants() {
        // Usamos el repositorio inyectado (Firebase) en lugar del Mock
        _ = repository.getRestaurantsFlow { [weak self] downloadedRestaurants in
            DispatchQueue.main.async {
                self?.restaurantsList = downloadedRestaurants
                
                // Si ya había un restaurante abierto, actualizamos su menú por si hubo cambios en la BD
                if let currentId = self?.currentRestaurantId, !currentId.isEmpty {
                    self?.currentMenu = downloadedRestaurants.first(where: { $0.id == currentId })?.menu ?? []
                }
            }
        }
    }
    
    func loadRestaurantData(restaurantId: String) {
        self.currentRestaurantId = restaurantId
        self.currentMenu = restaurantsList.first(where: { $0.id == restaurantId })?.menu ?? []
        loadSavedCart()
    }
    
    // --- PERFIL DE USUARIO ---
    private func loadUserProfile() {
            self.userProfile = LocalDatabaseManager.shared.getProfile()
    }
    
    func saveUserProfile(name: String, whatsapp: String, address: String, neighborhood: String, details: String) {
            let newProfile = UserProfile(name: name, whatsapp: whatsapp, address: address, neighborhood: neighborhood, details: details)
            self.userProfile = newProfile
            LocalDatabaseManager.shared.saveProfile(newProfile)
    }
    
    // --- FUNCIONES DEL CARRITO ---
    private func loadSavedCart() {
            self.cartItems = LocalDatabaseManager.shared.getCartItems(forRestaurantId: currentRestaurantId)
    }
    
    func addToCart(product: Product) {
        addCartItemFull(item: CartItem(product: product, quantity: 1, notes: "", selectedExtras: []))
    }
    
    func addCartItemFull(item: CartItem) {
        // Buscamos si existe un item con el mismo producto, notas y extras
        let existingIndex = cartItems.firstIndex { currentItem in
            let sameProduct = currentItem.product.id == item.product.id
            let sameNotes = currentItem.notes == item.notes
            
            // Comparamos los IDs de los extras para ver si son exactamente los mismos
            let currentExtraIds = Set(currentItem.selectedExtras.map { $0.id })
            let newExtraIds = Set(item.selectedExtras.map { $0.id })
            
            return sameProduct && sameNotes && currentExtraIds == newExtraIds
        }
        
        if let index = existingIndex {
            cartItems[index].quantity += item.quantity
            if !item.notes.isEmpty {
                cartItems[index].notes = item.notes
            }
        } else {
            cartItems.append(item)
        }
        
        syncCartWithDatabase()
    }
    
    func removeCartItem(itemToRemove: CartItem) {
        cartItems.removeAll { $0.id == itemToRemove.id }
        syncCartWithDatabase()
    }
    
    func removeAllOfProduct(productId: String) {
        cartItems.removeAll { $0.product.id == productId }
        syncCartWithDatabase()
    }
    
    func clearCart() {
        cartItems.removeAll()
        syncCartWithDatabase()
    }
    
    private func syncCartWithDatabase() {
        if cartItems.isEmpty {
            LocalDatabaseManager.shared.clearCart(forRestaurantId: currentRestaurantId)
        } else {
            LocalDatabaseManager.shared.saveCartItems(cartItems, forRestaurantId: currentRestaurantId)
        }
    }
    
    // --- GENERADOR DE MENSAJE (WHATSAPP) ---
    func generateWhatsAppMessage(restaurantName: String) -> String {
        let profileName = userProfile?.name ?? "Cliente"
        let address = userProfile?.address ?? "Sin dirección"
        let neighborhood = userProfile?.neighborhood ?? ""
        let details = userProfile?.details ?? ""
        let phone = userProfile?.whatsapp ?? "Sin teléfono"
        
        var message = "*¡Nuevo Pedido - Pa' Comer! 🍔*\n\n"
        message += "📍 *Restaurante:* \(restaurantName)\n"
        message += "👤 *Cliente:* \(profileName)\n"
        message += "📍 *Dirección:* \(address), \(neighborhood)\n"
        
        if !details.isEmpty {
            message += "🏠 *Detalles:* \(details)\n"
        }
        message += "📱 *WhatsApp:* \(phone)\n\n"
        
        message += "🛒 *Detalle del pedido:*\n"
        
        for item in cartItems {
            message += "• \(item.quantity)x \(item.product.name)"
            if !item.selectedExtras.isEmpty {
                let extrasStr = item.selectedExtras.map { $0.name }.joined(separator: ", ")
                message += " (Extras: \(extrasStr))"
            }
            if !item.notes.isEmpty {
                message += "\n   _Nota: \(item.notes)_"
            }
            message += "\n"
        }
        
        // Formateo de moneda
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        
        let formattedTotal = formatter.string(from: NSNumber(value: cartTotalPrice)) ?? "$\(cartTotalPrice)"
        
        message += "\n💰 *TOTAL A PAGAR: \(formattedTotal)*"
        message += "\n\nGenerado desde la App Pa' Comer ✨"
        
        return message
    }
    
    // --- FUNCIONES DE INTERFAZ ---
    func clearFilters() {
        sortOrder = .none
        priceRange = 0...100000
        selectedCategory = "Todo"
    }
    
    func getProductById(productId: String) -> Product? {
        return currentMenu.first { $0.id == productId }
    }
    
    func triggerOrderSuccess() { showOrderSuccessModal = true }
    func dismissOrderSuccess() { showOrderSuccessModal = false }
}
