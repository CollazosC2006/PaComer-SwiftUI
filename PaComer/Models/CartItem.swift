//
//  CartItem.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

struct CartItem: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var product: Product
    var quantity: Int
    var notes: String = ""
    var selectedExtras: [Extra] = []
    
    // Propiedad calculada (Equivalente al get() de Kotlin)
    var totalPrice: Double {
        // sumOf de Kotlin se traduce a reduce en Swift
        let extrasTotal = selectedExtras.reduce(0.0) { result, extra in
            result + extra.price
        }
        return (product.price + extrasTotal) * Double(quantity)
    }
}
