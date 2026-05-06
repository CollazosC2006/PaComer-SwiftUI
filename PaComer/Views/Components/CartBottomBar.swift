//
//  CartBottomBar.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

// MARK: - Cart Bottom Bar
struct CartBottomBar: View {
    var totalItems: Int
    var totalPrice: Double
    var onCheckoutClick: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(totalItems == 1 ? "1 item añadido" : "\(totalItems) items añadidos")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(formatCurrency(totalPrice))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: onCheckoutClick) {
                HStack {
                    Text("Ver carrito")
                        .fontWeight(.bold)
                    Image(systemName: "cart.fill")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "F97316"))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(hex: "111827"))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
