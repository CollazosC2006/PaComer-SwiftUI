import SwiftUI
import UIKit

// Definimos las rutas posibles para nuestra navegación
enum AppRoute: Hashable {
    case home
    case menu(Restaurant)
    case detail(Product)
    case cart
    case checkout
    case editDelivery
    case about
}

struct AppNavigation: View {
    // Aquí inicializamos el ViewModel central de la app
    @StateObject private var viewModel = RestaurantMenuViewModel()
    
    // Este objeto controla la pila de navegación (el historial)
    @State private var path = NavigationPath()
    
    // Estados para las alertas tipo "Toast"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            // Pantalla de Inicio (home_screen)
            HomeScreen(
                restaurants: viewModel.restaurantsList,
                onRestaurantClick: { clickedRestaurant in
                    // 👇 VALIDACIÓN: ¿El restaurante tiene menú?
                    if clickedRestaurant.menu.isEmpty {
                        alertMessage = "Lo sentimos, este restaurante no tiene disponible su menú en estos momentos"
                        showAlert = true
                    } else {
                        // Navegamos pasando el objeto completo, no solo el ID
                        path.append(AppRoute.menu(clickedRestaurant))
                    }
                },
                onAboutClick: {
                    path.append(AppRoute.about)
                }
            )
            .background(SwipeBackHelper())
            .alert("Aviso", isPresented: $showAlert) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            // Aquí definimos hacia dónde ir según el tipo de ruta
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    EmptyView() // No aplica porque ya es la raíz
                    
                case .menu(let restaurant):
                    RestaurantMenuScreen(
                        restaurant: restaurant,
                        onBackClick: { path.removeLast() },
                        onProductClick: { product in
                            path.append(AppRoute.detail(product))
                        },
                        onCartClick: {
                            path.append(AppRoute.cart)
                        }
                    )
                    .onAppear {
                        viewModel.loadRestaurantData(restaurantId: restaurant.id)
                    }
                    
                case .detail(let product):
                    ProductDetailScreen(
                        product: product,
                        onBackClick: { path.removeLast() }
                    )
                    
                case .cart:
                    CartScreen(
                        onBackClick: { path.removeLast() },
                        onPlaceOrder: {
                            if viewModel.userProfile == nil || (viewModel.userProfile?.whatsapp.isEmpty ?? true) {
                                alertMessage = "Por favor, completa tus datos de entrega para continuar con el pedido"
                                showAlert = true
                                path.append(AppRoute.editDelivery)
                            } else {
                                path.append(AppRoute.checkout)
                            }
                        }
                    )
                    
                case .checkout:
                    // Buscamos el restaurante actual (en nuestro MVP es el primero con menú)
                    if let currentRest = viewModel.restaurantsList.first(where: { !$0.menu.isEmpty }) {
                        CheckoutScreen(
                            restaurant: currentRest,
                            onBackClick: { path.removeLast() },
                            onConfirmOrder: { metodoPago in
                                // 1. Generamos el texto del mensaje usando el ViewModel
                                let mensaje = viewModel.generateWhatsAppMessage(restaurantName: currentRest.name)
                                
                                // 2. Preparamos el número (Si está vacío, usamos un default de prueba)
                                let phoneNumber = currentRest.whatsappNumber.isEmpty ? "573000000000" : currentRest.whatsappNumber
                                
                                // 3. Codificamos el mensaje para que sea válido en una URL
                                if let encodedMessage = mensaje.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let url = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(encodedMessage)") {
                                    
                                    // 4. Abrimos WhatsApp nativamente en iOS
                                    UIApplication.shared.open(url)
                                    
                                    // 5. Lógica de limpieza post-pedido
                                    viewModel.clearCart()
                                    viewModel.triggerOrderSuccess()
                                    
                                    // 6. Volvemos al menú principal (vaciando toda la pila)
                                    path.removeLast(path.count)
                                }
                            },
                            onEditDeliveryClick: {
                                path.append(AppRoute.editDelivery)
                            }
                        )
                    }
                    
                case .editDelivery:
                    EditDeliveryInfoScreen(
                        userProfile: viewModel.userProfile,
                        onBackClick: { path.removeLast() },
                        onSaveClick: { name, whatsapp, address, neighborhood, details in
                            // Guardamos en la Base de Datos Local usando el ViewModel
                            viewModel.saveUserProfile(
                                name: name,
                                whatsapp: whatsapp,
                                address: address,
                                neighborhood: neighborhood,
                                details: details
                            )
                            // Regresamos a la pantalla anterior
                            path.removeLast()
                        }
                    )
                    
                case .about:
                    AboutScreen(onBackClick: { path.removeLast() })
                }
            }
        }
        // Inyectamos el ViewModel a TODO el NavigationStack
        .environmentObject(viewModel)
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    // Se ejecuta automáticamente al cargar cualquier controlador de navegación
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Le decimos a iOS que nosotros controlaremos el gesto
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // iOS nos pregunta: "¿Debo permitir que el usuario deslice para volver?"
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Solo permitimos el gesto si hay más de una pantalla en la pila (para no cerrar la app accidentalmente)
        return viewControllers.count > 1
    }
}

// MARK: - Helper para restaurar el gesto de Atrás nativo
struct SwipeBackHelper: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var navController: UINavigationController?
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return (navController?.viewControllers.count ?? 0) > 1
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear // Lo hacemos invisible
        
        // Esperamos a que la vista se dibuje para capturar el controlador
        DispatchQueue.main.async {
            if let nav = vc.navigationController {
                context.coordinator.navController = nav
                nav.interactivePopGestureRecognizer?.delegate = context.coordinator
            }
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
