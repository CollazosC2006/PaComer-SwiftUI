//
//  Product.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
    var description: String = ""
    var price: Double = 0.0
    var category: String = ""
    var imageUrl: String = ""
    var extras: [Extra] = []
}
