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
                // Placeholder de imagen
                Color(hex: "E5E7EB")
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                
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
                    
                    HStack {
                        Text("$\(Int(product.price))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "F97316"))
                        
                        Spacer()
                        
                        Button(action: onAddClick) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "F97316"))
                                .padding(8)
                                .background(Color(hex: "FFF7ED"))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
