//
//  Extra.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

struct Extra: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
    var price: Double = 0.0
}
