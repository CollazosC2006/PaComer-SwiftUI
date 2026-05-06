//
//  CartScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct CartScreen: View {
    var onBackClick: () -> Void
    var onPlaceOrder: () -> Void
    
    var body: some View {
        VStack {
            Text("Pantalla de tu Carrito")
                .font(.title)
            
            Button("Hacer Pedido") {
                onPlaceOrder()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
