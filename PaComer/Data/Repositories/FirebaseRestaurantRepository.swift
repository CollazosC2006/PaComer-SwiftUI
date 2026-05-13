//
//  FirebaseRestaurantRepository.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation
import FirebaseFirestore

class FirebaseRestaurantRepository: RestaurantRepositoryProtocol {
    private let db = Firestore.firestore()
    
    // Usamos un 'completion' para devolver la lista cada vez que haya un cambio en la BD
    // Retornamos el ListenerRegistration para poder detener la escucha cuando ya no se necesite
    func getRestaurantsFlow(completion: @escaping ([Restaurant]) -> Void) -> ListenerRegistration {
        
        // Escuchamos la colección "restaurants" en tiempo real
        let subscription = db.collection("restaurants").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error al obtener restaurantes: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            // Convertimos los documentos de Firebase a nuestro arreglo de objetos Swift
            // 'compactMap' descarta automáticamente los documentos que no coincidan con el modelo
            /*let restaurants = documents.compactMap { doc -> Restaurant? in
                try? doc.data(as: Restaurant.self)
            }*/
            let restaurants = documents.compactMap { doc -> Restaurant? in
                            do {
                                // Intentamos decodificar
                                print("Error decodificando el restaurante ")
                                return try doc.data(as: Restaurant.self)
                            } catch {
                                // ¡Si falla, que nos grite en la consola qué campo está mal!
                                print("⚠️ Error decodificando el restaurante \(doc.documentID): \(error)")
                                return nil
                            }
                        }
                        
                        
            
            completion(restaurants)
        }
        
        return subscription
    }
}
