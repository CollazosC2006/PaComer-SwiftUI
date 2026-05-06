//
//  CartScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct CartScreen: View {
    var onBackClick: () -> Void
    var onPlaceOrder: () -> Void
    
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    
    // Estado para el modal de eliminación
    @State private var productToDelete: Product? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP APP BAR ---
                HStack {
                    Button(action: onBackClick) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Tu Pedido")
                        .font(.headline)
                        .fontWeight(.black)
                    Spacer()
                    // Añadimos un botón invisible para centrar el título perfectamente
                    Color.clear.frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                if viewModel.cartItems.isEmpty {
                    // --- ESTADO VACÍO ---
                    VStack {
                        Spacer()
                        Image(systemName: "cart")
                            .font(.system(size: 64))
                            .foregroundColor(Color.gray.opacity(0.3))
                        Text("Tu carrito está vacío")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                        Spacer()
                    }
                } else {
                    // --- LISTA AGRUPADA ---
                    ScrollView {
                        VStack(spacing: 16) {
                            // Agrupamos el array de items usando el producto como llave
                            let grouped = Dictionary(grouping: viewModel.cartItems) { $0.product }
                            
                            // Iteramos sobre las llaves ordenadas para mantener consistencia
                            ForEach(grouped.keys.sorted(by: { $0.name < $1.name })) { product in
                                if let variations = grouped[product] {
                                    GroupedCartItemCard(
                                        product: product,
                                        variations: variations,
                                        onRemoveGroup: {
                                            productToDelete = product
                                            showDeleteAlert = true
                                        },
                                        onRemoveItem: { item in
                                            viewModel.removeCartItem(itemToRemove: item)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 100) // Espacio para el botón flotante
                    }
                }
            }
            
            // --- BARRA INFERIOR DE PAGO ---
            if !viewModel.cartItems.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total a pagar")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(formatCurrency(viewModel.cartTotalPrice))
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(Color(hex: "111827"))
                        }
                        
                        Spacer()
                        
                        Button(action: onPlaceOrder) {
                            Text("Hacer pedido")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color(hex: "F97316"))
                                .cornerRadius(16)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
                }
            }
        }
        .navigationBarHidden(true)
        // ALERTA DE ELIMINACIÓN
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Eliminar producto"),
                message: Text("¿Estás seguro de que deseas eliminar todas las variaciones de \(productToDelete?.name ?? "") del carrito?"),
                primaryButton: .destructive(Text("Sí, eliminar")) {
                    if let product = productToDelete {
                        viewModel.removeAllOfProduct(productId: product.id)
                    }
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}

// MARK: - Tarjeta Agrupada (Acordeón)
struct GroupedCartItemCard: View {
    var product: Product
    var variations: [CartItem]
    var onRemoveGroup: () -> Void
    var onRemoveItem: (CartItem) -> Void
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        let groupTotalQty = variations.reduce(0) { $0 + $1.quantity }
        let groupTotalPrice = variations.reduce(0.0) { $0 + $1.totalPrice }
        
        VStack(spacing: 0) {
            // CABECERA (Clickeable)
            Button(action: {
                withAnimation(.easeInOut) { isExpanded.toggle() }
            }) {
                HStack(alignment: .center, spacing: 12) {
                    
                    // Imagen
                    ZStack {
                        Color(hex: "EEEEEE").frame(width: 64, height: 64).cornerRadius(16)
                        if !product.imageUrl.isEmpty {
                            AsyncImage(url: URL(string: product.imageUrl)) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFill()
                                }
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Image(systemName: "photo").foregroundColor(.gray)
                        }
                    }
                    
                    // Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "111827"))
                        Text("\(groupTotalQty) items • \(formatCurrency(groupTotalPrice))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "F97316"))
                    }
                    
                    Spacer()
                    
                    // Botón Borrar Todo
                    Button(action: onRemoveGroup) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red.opacity(0.7))
                            .padding(8)
                    }
                    
                    // Flecha
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // CONTENIDO DESPLEGABLE (Detalle)
            if isExpanded {
                VStack(spacing: 0) {
                    Divider().padding(.horizontal, 16).padding(.bottom, 8)
                    
                    ForEach(variations) { item in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(item.quantity)x")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "111827"))
                                .frame(width: 32, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if !item.selectedExtras.isEmpty {
                                    let extras = item.selectedExtras.map { $0.name }.joined(separator: ", ")
                                    Text("Extras: \(extras)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Sin extras")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                if !item.notes.isEmpty {
                                    Text("Nota: \(item.notes)")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "F97316"))
                                }
                                
                                Text(formatCurrency(item.totalPrice))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "111827"))
                                    .padding(.top, 4)
                            }
                            
                            Spacer()
                            
                            Button(action: { onRemoveItem(item) }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
                .background(Color(hex: "F9FAFB"))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
