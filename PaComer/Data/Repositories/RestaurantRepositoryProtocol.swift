//
//  RestaurantRepositoryProtocol.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//
import Foundation
import FirebaseFirestore // <-- ¡Agrega esta línea!

protocol RestaurantRepositoryProtocol {
    func getRestaurantsFlow(completion: @escaping ([Restaurant]) -> Void) -> ListenerRegistration
}
