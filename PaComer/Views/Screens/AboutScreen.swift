//
//  AboutScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct AboutScreen: View {
    var onBackClick: () -> Void
    
    var body: some View {
        VStack {
            Text("Acerca de Pa' Comer")
                .font(.largeTitle)
                .bold()
        }
        .navigationBarHidden(true)
    }
}
