//
//  Restaurant.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

struct Restaurant: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
    var description: String = ""
    var rating: Double = 0.0
    var deliveryTime: String = ""
    var menu: [Product] = []
    var accountNumberNequi: String = ""
    var accountNumberBreb: String = ""
    var imageUrl: String = ""
    var whatsappNumber: String = ""
}
