//
//  LocalDatabaseManager.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

class LocalDatabaseManager {
    // Patrón Singleton, igual que la instancia de base de datos en Android
    static let shared = LocalDatabaseManager()
    
    private let defaults = UserDefaults.standard
    
    // Claves para guardar en la memoria local
    private let profileKey = "user_profile_key"
    private let cartKeyPrefix = "cart_items_restaurant_"
    
    private init() {} // Evita que se creen múltiples instancias
    
    // MARK: - Equivalente a UserProfileDao
    
    func saveProfile(_ profile: UserProfile) {
        // En Swift, JSONEncoder hace el trabajo que hacía Gson
        if let encoded = try? JSONEncoder().encode(profile) {
            defaults.set(encoded, forKey: profileKey)
        }
    }
    
    func getProfile() -> UserProfile? {
        if let savedData = defaults.data(forKey: profileKey),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            return decodedProfile
        }
        return nil
    }
        
    func saveCartItems(_ items: [CartItem], forRestaurantId restaurantId: String) {
        let key = cartKeyPrefix + restaurantId
        if let encoded = try? JSONEncoder().encode(items) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func getCartItems(forRestaurantId restaurantId: String) -> [CartItem] {
        let key = cartKeyPrefix + restaurantId
        if let savedData = defaults.data(forKey: key),
           let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedData) {
            return decodedItems
        }
        return []
    }
    
    func clearCart(forRestaurantId restaurantId: String) {
        let key = cartKeyPrefix + restaurantId
        defaults.removeObject(forKey: key)
    }
}
