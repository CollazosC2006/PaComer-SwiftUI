//
//  HomeScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct HomeScreen: View {
    // Recibimos los parámetros igual que en Kotlin
    var restaurants: [Restaurant]
    var onRestaurantClick: (Restaurant) -> Void
    var onAboutClick: () -> Void
    
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
        // ZStack nos permite poner el fondo gris claro detrás de todo (como el Scaffold de Compose)
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // 1. CABECERA
                    HStack {
                        HStack(spacing: 12) {
                            // Cambia "logo_pacomer" por el nombre exacto de la imagen si ya la subiste a Assets
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
                                .foregroundColor(Color(hex: "F97316")) // Naranja
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
                    
                    // 3. LISTA DE RESTAURANTES (LazyVStack en lugar de LazyColumn)
                    LazyVStack(spacing: 20) {
                        ForEach(filteredRestaurants) { restaurant in
                            RestaurantCard(restaurant: restaurant, onClick: {
                                onRestaurantClick(restaurant)
                            })
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        // Ocultamos la barra de navegación nativa porque tenemos nuestra cabecera custom
        .navigationBarHidden(true)
    }
}

// MARK: - Componente de Tarjeta
struct RestaurantCard: View {
    var restaurant: Restaurant
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: 0) {
                
                // Imagen y Badge
                ZStack(alignment: .topTrailing) {
                    Color(hex: "E5E7EB") // Fondo gris mientras carga
                        .frame(height: 160)
                    
                    // Coil (Android) vs AsyncImage (iOS)
                    if !restaurant.imageUrl.isEmpty {
                        AsyncImage(url: URL(string: restaurant.imageUrl)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            }
                        }
                        .frame(height: 160)
                        .clipped()
                    }
                    
                    // Badge de calificación
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color(hex: "F59E0B"))
                        
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "111827"))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(12)
                }
                
                // Información del restaurante
                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Color(hex: "111827"))
                    
                    Text(restaurant.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height: 8)
                    
                    // Detalles con íconos
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Color(hex: "F97316"))
                            Text("-- km").font(.system(size: 12)).foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "banknote.fill")
                                .foregroundColor(Color(hex: "10B981"))
                            Text("$$").font(.system(size: 12)).foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.gray)
                            Text(restaurant.deliveryTime).font(.system(size: 12)).foregroundColor(.gray)
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Evita que todo el botón se ponga azul al presionarlo
    }
}
