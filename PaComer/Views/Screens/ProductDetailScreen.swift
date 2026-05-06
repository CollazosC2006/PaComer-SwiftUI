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
    
    // Conexión al ViewModel global para agregar al carrito
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    
    // Estados locales
    @State private var quantity: Int = 1
    @State private var notes: String = ""
    @State private var selectedExtras: [String: Extra] = [:] // Equivalente a mutableStateMapOf
    
    // Cálculo reactivo
    var currentTotal: Double {
        let extrasPrice = selectedExtras.values.reduce(0.0) { $0 + $1.price }
        return (product.price + extrasPrice) * Double(quantity)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // --- CAPA 1: IMAGEN DE FONDO FIJA ---
            VStack {
                ZStack(alignment: .bottom) {
                    Color(hex: "E5E7EB").frame(height: 280)
                    
                    if !product.imageUrl.isEmpty {
                        AsyncImage(url: URL(string: product.imageUrl)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            }
                        }
                        .frame(height: 280)
                        .clipped()
                    }
                    
                    // Gradiente oscuro en la parte inferior de la imagen
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                }
                Spacer() // Empuja la imagen hacia arriba
            }
            .ignoresSafeArea(edges: .top)
            
            // --- CAPA 2: CONTENIDO (SCROLL) ---
            ScrollView {
                VStack(spacing: 0) {
                    // Spacer transparente para dejar ver la imagen de fondo
                    Color.clear.frame(height: 250)
                    
                    // Tarjeta blanca con bordes redondeados
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // Título y Precio
                        HStack(alignment: .top) {
                            Text(product.name)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(Color(hex: "111827"))
                                .lineSpacing(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(formatCurrency(product.price))
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(Color(hex: "F97316"))
                                .padding(.leading, 16)
                        }
                        .padding(.bottom, 8)
                        
                        Text(product.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Divider().padding(.vertical, 24)
                        
                        // Extras
                        if !product.extras.isEmpty {
                            HStack {
                                Text("Extras")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "111827"))
                                Spacer()
                                Text("Opcional")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 12)
                            
                            ForEach(product.extras) { extra in
                                let isChecked = selectedExtras.keys.contains(extra.id)
                                
                                ExtraCheckboxOption(
                                    name: extra.name,
                                    price: extra.price,
                                    isChecked: isChecked,
                                    onCheckedChange: { checked in
                                        if checked {
                                            selectedExtras[extra.id] = extra
                                        } else {
                                            selectedExtras.removeValue(forKey: extra.id)
                                        }
                                    }
                                )
                                .padding(.bottom, 8)
                            }
                            Spacer().frame(height: 16)
                        }
                        
                        // Notas para la cocina
                        Text("Notas para la cocina")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.bottom, 12)
                        
                        // Campo de texto para notas
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Ej. Sin cebolla...")
                                    .foregroundColor(.gray)
                                    .padding(16)
                            }
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(8)
                                .opacity(notes.isEmpty ? 0.2 : 1) // Truco visual para el placeholder nativo
                        }
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "F3F4F6"), lineWidth: 1)
                        )
                        
                        // Espacio al final para que la barra inferior no tape el contenido
                        Spacer().frame(height: 120)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(32, corners: [.topLeft, .topRight]) // Requiere la extensión que creamos antes
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // --- CAPA 3: BOTÓN ATRÁS SUPERIOR ---
            VStack {
                HStack {
                    Button(action: onBackClick) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                Spacer()
            }
            
            // --- CAPA 4: BARRA INFERIOR ---
            VStack {
                Spacer()
                HStack(spacing: 16) {
                    
                    // Cantidad
                    HStack {
                        Button(action: { if quantity > 1 { quantity -= 1 } }) {
                            Image(systemName: "minus")
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                        }
                        
                        Text("\(quantity)")
                            .font(.system(size: 16, weight: .bold))
                            .frame(minWidth: 20)
                        
                        Button(action: { quantity += 1 }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .frame(width: 40, height: 40)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(4)
                    .background(Color(hex: "F3F4F6"))
                    .cornerRadius(16)
                    
                    // Botón Agregar
                    Button(action: {
                        let finalNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
                        let item = CartItem(
                            product: product,
                            quantity: quantity,
                            notes: finalNotes,
                            selectedExtras: Array(selectedExtras.values)
                        )
                        viewModel.addCartItemFull(item: item)
                        onBackClick() // Ejecutamos la acción de regresar
                    }) {
                        Text("Agregar • \(formatCurrency(currentTotal))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color(hex: "111827"))
                            .cornerRadius(16)
                    }
                }
                .padding(16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            }
        }
        .navigationBarHidden(true)
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}

// Componente reutilizable para los checkbox de extras
struct ExtraCheckboxOption: View {
    var name: String
    var price: Double
    var isChecked: Bool
    var onCheckedChange: (Bool) -> Void
    
    var body: some View {
        Button(action: { onCheckedChange(!isChecked) }) {
            HStack {
                HStack(spacing: 12) {
                    // Checkbox
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isChecked ? Color(hex: "F97316") : Color(hex: "D1D5DB"), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isChecked {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "F97316"))
                                .frame(width: 20, height: 20)
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "111827"))
                }
                
                Spacer()
                
                Text("+\(formatCurrency(price))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(isChecked ? Color(hex: "FFF7ED") : Color.clear)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isChecked ? Color(hex: "F97316").opacity(0.3) : Color(hex: "F3F4F6"), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
