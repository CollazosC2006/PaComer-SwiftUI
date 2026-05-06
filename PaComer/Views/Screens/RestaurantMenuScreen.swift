//
//  RestaurantMenuScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct RestaurantMenuScreen: View {
    var restaurant: Restaurant
    
    // Conectamos directamente con el ViewModel global
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    
    var onBackClick: () -> Void
    var onProductClick: (Product) -> Void
    var onCartClick: () -> Void
    
    @State private var showFilterSheet = false
    @State private var showPriceInfo = false
    
    var body: some View {
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP APP BAR CUSTOM ---
                HStack {
                    Button(action: onBackClick) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text(restaurant.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { showPriceInfo = true }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "F97316"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                // --- BUSCADOR ---
                SearchBar(
                    query: $viewModel.searchQuery,
                    onFilterClick: { showFilterSheet = true }
                )
                
                // --- CATEGORÍAS ---
                CategoryList(
                    categories: viewModel.availableCategories,
                    selectedCategory: $viewModel.selectedCategory
                )
                
                // --- LISTA DE PRODUCTOS ---
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredMenu) { product in
                            // Calculamos cuántos de este producto hay en el carrito
                            let quantity = viewModel.cartItems
                                .filter { $0.product.id == product.id }
                                .reduce(0) { $0 + $1.quantity }
                            
                            ProductCard(
                                product: product,
                                quantity: quantity,
                                onCardClick: { onProductClick(product) },
                                onAddClick: { viewModel.addToCart(product: product) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100) // Espacio para que el carrito no tape el último item
                }
            }
            
            // --- TOOLTIP DE PRECIOS ---
            if showPriceInfo {
                VStack {
                    HStack {
                        Spacer()
                        PriceInfoTooltip()
                            .padding(.trailing, 20)
                            .padding(.top, 50)
                            .onAppear {
                                // Desaparece tras 5 segundos
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation { showPriceInfo = false }
                                }
                            }
                    }
                    Spacer()
                }
                .zIndex(2) // Asegura que flote sobre todo
            }
            
            // --- BOTÓN FLOTANTE DEL CARRITO ---
            VStack {
                Spacer()
                if viewModel.cartTotalItems > 0 {
                    CartBottomBar(
                        totalItems: viewModel.cartTotalItems,
                        totalPrice: viewModel.cartTotalPrice,
                        onCheckoutClick: onCartClick
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    // Animación de entrada y salida equivalente a AnimatedVisibility
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: viewModel.cartTotalItems > 0)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showFilterSheet) {
            FilterBottomSheet(isPresented: $showFilterSheet)
                .presentationDetents([.medium]) // Hace que el modal ocupe solo media pantalla
        }
        .onAppear {
            // Mostramos el info si el carrito está vacío al entrar
            if viewModel.cartItems.isEmpty {
                showPriceInfo = true
            }
        }
    }
}
