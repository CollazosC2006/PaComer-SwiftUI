//
//  PaComerApp.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI
import FirebaseCore // Importamos el núcleo de Firebase

// Clase delegada para interceptar el arranque de la app e inicializar Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // ¡Encendemos los motores de Firebase!
        FirebaseApp.configure()
        return true
    }
}

@main
struct PaComerApp: App {
    // Registramos el delegado en el ciclo de vida de SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppNavigation()
        }
    }
}
