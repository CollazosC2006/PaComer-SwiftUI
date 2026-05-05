//
//  AppNavigation.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

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
                    // Dejamos esto temporalmente con EmptyView hasta que lo creemos
                    Text("CheckoutScreen")
                        .navigationTitle("Checkout")
                    
                case .editDelivery:
                    Text("EditDeliveryInfoScreen")
                        .navigationTitle("Tus Datos")
                    
                case .about:
                    AboutScreen(onBackClick: { path.removeLast() })
                }
            }
        }
        // Inyectamos el ViewModel a TODO el NavigationStack
        .environmentObject(viewModel)
    }
}
