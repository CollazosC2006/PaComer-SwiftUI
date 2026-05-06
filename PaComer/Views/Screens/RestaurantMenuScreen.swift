//
//  RestaurantMenuScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct RestaurantMenuScreen: View {
    var restaurant: Restaurant
    var onBackClick: () -> Void
    var onProductClick: (Product) -> Void
    var onCartClick: () -> Void
    
    var body: some View {
        VStack {
            Text("Bienvenido al menú de:")
            Text(restaurant.name)
                .font(.largeTitle)
                .bold()
            
            Button("Ver un producto de prueba") {
                if let primerProducto = restaurant.menu.first {
                    onProductClick(primerProducto)
                }
            }
            .padding()
            
            Button("Ir al carrito") {
                onCartClick()
            }
        }
        .navigationBarHidden(true) // Ocultamos la nativa porque haremos la nuestra
    }
}
