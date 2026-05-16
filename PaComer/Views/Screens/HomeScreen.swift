//
//  HomeScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct HomeScreen: View {
    // Recibimos los parámetros
    var restaurants: [Restaurant]
    var onRestaurantClick: (Restaurant) -> Void
    var onAboutClick: () -> Void
    
    // Nos conectamos al ViewModel para escuchar cuando el pedido es exitoso
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    
    // Estado local para la búsqueda
    @State private var searchQuery: String = ""
    
    // Variable calculada para filtrar
    var filteredRestaurants: [Restaurant] {
        if searchQuery.isEmpty { return restaurants }
        return restaurants.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.description.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // 1. CABECERA
                    HStack {
                        HStack(spacing: 12) {
                            Image("logo_pacomer")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text("Pa' comer")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(Color(hex: "111827"))
                        }
                        
                        Spacer()
                        
                        Button(action: onAboutClick) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color(hex: "F97316"))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle().stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // 2. BARRA DE BÚSQUEDA
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Buscar restaurantes...", text: $searchQuery)
                            .foregroundColor(.black)
                            .submitLabel(.search) // Cambia el botón de "Intro" por "Buscar" en el teclado
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    // 3. LISTA DE RESTAURANTES
                    LazyVStack(spacing: 20) {
                        ForEach(filteredRestaurants) { restaurant in
                            RestaurantCard(restaurant: restaurant, onClick: {
                                // Forzamos a que el teclado se cierre si estaba abierto antes de navegar
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                onRestaurantClick(restaurant)
                            })
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            
            // --- MODAL DE ÉXITO (¡Pedido Confirmado!) ---
            if viewModel.showOrderSuccessModal {
                ZStack {
                    // Fondo oscuro semitransparente
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "10B981")) // Verde Esmeralda
                        
                        Text("¡Pedido Confirmado!")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(Color(hex: "111827"))
                        
                        Text("Tu pedido ha sido registrado con éxito. El restaurante se pondrá en contacto contigo muy pronto para terminar el proceso de logística de entrega.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        
                        Button(action: {
                            viewModel.dismissOrderSuccess()
                        }) {
                            Text("Aceptar")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color(hex: "10B981")) // Verde Esmeralda
                                .cornerRadius(16)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 40)
                }
                .zIndex(2) // Asegura que el modal flote sobre toda la interfaz
                // Animación suave de aparición
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut, value: viewModel.showOrderSuccessModal)
            }
        }
    }
}
