//
//  ProductDetailScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct ProductDetailScreen: View {
    var product: Product
    var onBackClick: () -> Void
    
    var body: some View {
        VStack {
            Text("Detalle del Producto:")
            Text(product.name)
                .font(.largeTitle)
                .bold()
        }
        .navigationBarHidden(true)
    }
}
