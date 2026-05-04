//
//  HomeScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
