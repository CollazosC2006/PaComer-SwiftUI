//
//  ProductCard.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//
import SwiftUI

struct ProductCard: View {
    var product: Product
    var quantity: Int
    var onCardClick: () -> Void
    var onAddClick: () -> Void
    
    var body: some View {
        Button(action: onCardClick) {
            HStack(spacing: 16) {
                
                // Imagen con AsyncImage (igual que en tu Kotlin con Coil)
                ZStack {
                    Color(hex: "E5E7EB") // Fondo gris mientras carga
                        .frame(width: 96, height: 96)
                        .cornerRadius(16)
                    
                    if !product.imageUrl.isEmpty {
                        AsyncImage(url: URL(string: product.imageUrl)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            }
                        }
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                
                // Información del producto
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                        .multilineTextAlignment(.leading)
                    
                    Text(product.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 8)
                    
                    HStack {
                        Text(formatCurrency(product.price))
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(Color(hex: "111827"))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            
                            // ANIMACIÓN DE CANTIDAD
                            if quantity > 0 {
                                Text("\(quantity)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "F97316"))
                                    .frame(width: 32, height: 32)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color(hex: "F97316"), lineWidth: 1)
                                    )
                                    // La transición equivalente a Kotlin: fade + scale + slide
                                    .transition(
                                        .asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale),
                                            removal: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale)
                                        )
                                    )
                            }
                            
                            // Botón de agregar "+"
                            Button(action: onAddClick) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "F97316"))
                                    .frame(width: 32, height: 32)
                                    .background(Color(hex: "FFF7ED"))
                                    .clipShape(Circle())
                            }
                        }
                        // Esta animación suaviza la entrada/salida del círculo de cantidad
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: quantity)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Función para formateo de moneda nativo
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
