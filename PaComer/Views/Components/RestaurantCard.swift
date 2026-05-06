//
//  RestaurantCard.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 5/05/26.
//

import SwiftUI

struct RestaurantCard: View {
    var restaurant: Restaurant
    var onClick: () -> Void
    
    var body: some View {
        // SOLUCIÓN AL BUG: Cambiamos "Button" por "VStack + onTapGesture"
        VStack(alignment: .leading, spacing: 0) {
            
            // Imagen y Badge
            ZStack(alignment: .topTrailing) {
                Color(hex: "E5E7EB") // Fondo gris mientras carga
                    .frame(height: 160)
                
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
        // Permite que todo el rectángulo detecte el toque de manera segura
        .contentShape(Rectangle())
        .onTapGesture {
            onClick()
        }
    }
}
