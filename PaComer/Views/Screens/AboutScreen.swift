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
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP APP BAR ---
                HStack {
                    Button(action: onBackClick) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Acerca de la App")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Color.clear.frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Spacer().frame(height: 32)
                        
                        // 1. Logo de la App
                        Image("logo_pacomer") // Asegúrate de que el asset se llame así
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        Spacer().frame(height: 16)
                        
                        // 2. Nombre y Versión
                        Text("Pa' Comer")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(Color(hex: "111827"))
                        
                        Text("Versión 1.0.0")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height: 24)
                        
                        // 3. Tarjeta de Descripción del Proyecto
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Color(hex: "F97316"))
                                Text("Sobre el Proyecto")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "111827"))
                            }
                            .padding(.bottom, 4)
                            
                            Text("Plataforma de delivery local y menú virtual para restaurantes. La app fue creada con el fin de que los usuarios puedan visualizar los menús del restaurante con los precios tal cual se ofrecen en el restaurante y sin necesidad de inflar precios en la app, de modo que la app tambien sirve como menú virtual para el restaurante. Además se ofrece la logistica de delivery de modo que las personas puedan hacer sus pedidos de forma facil e interactiva.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        Spacer().frame(height: 24)
                        
                        // 4. Tarjeta del Desarrollador
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Desarrollado por")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                            
                            Text("Carlos Collazos")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(Color(hex: "111827"))
                                .padding(.bottom, 12)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "graduationcap.fill")
                                    .foregroundColor(Color(hex: "F97316"))
                                    .frame(width: 32, height: 32)
                                    .background(Color(hex: "FFF7ED"))
                                    .clipShape(Circle())
                                
                                Text("Estudiante de Ing. Electrónica y Telecomunicaciones")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .lineSpacing(2)
                            }
                            .padding(.bottom, 12)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "chevron.left.slash.chevron.right")
                                    .foregroundColor(Color(hex: "7E22CE"))
                                    .frame(width: 32, height: 32)
                                    .background(Color(hex: "F3E8FF"))
                                    .clipShape(Circle())
                                
                                Text("Desarrollador Cloud Fullstack")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        Spacer().frame(height: 40)
                        
                        Text("Universidad del Cauca © 2026")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
