//
//  EditDeliveryInfoScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 5/05/26.
//

import SwiftUI

struct EditDeliveryInfoScreen: View {
    var userProfile: UserProfile?
    var onBackClick: () -> Void
    var onSaveClick: (String, String, String, String, String) -> Void
    
    // ESTADOS Y DATOS POR DEFECTO
    @State private var name: String
    @State private var whatsapp: String
    @State private var address: String
    @State private var neighborhood: String
    @State private var details: String
    
    // Constructor para inicializar los estados con el perfil si existe
    init(userProfile: UserProfile?, onBackClick: @escaping () -> Void, onSaveClick: @escaping (String, String, String, String, String) -> Void) {
        self.userProfile = userProfile
        self.onBackClick = onBackClick
        self.onSaveClick = onSaveClick
        
        _name = State(initialValue: userProfile?.name ?? "")
        _whatsapp = State(initialValue: userProfile?.whatsapp ?? "")
        _address = State(initialValue: userProfile?.address ?? "")
        _neighborhood = State(initialValue: userProfile?.neighborhood ?? "")
        _details = State(initialValue: userProfile?.details ?? "")
    }
    
    // Validación
    var isFormValid: Bool {
        !name.isEmpty && !whatsapp.isEmpty && !address.isEmpty && !neighborhood.isEmpty
    }
    
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
                    Text("Datos de Entrega")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Color.clear.frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Ingresa tus datos reales para evitar contratiempos con la entrega de tu pedido.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                            .padding(.bottom, 8)
                        
                        // CAMPO 1: Nombre
                        CustomInputField(
                            value: $name,
                            label: "Nombre completo",
                            placeholder: "Ej. María Gómez",
                            icon: "person.fill",
                            iconTint: .gray
                        )
                        .onChange(of: name) { newValue in
                            // Solo letras y espacios
                            let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                            if name != filtered { name = filtered }
                        }
                        
                        // CAMPO 2: WhatsApp
                        CustomInputField(
                            value: $whatsapp,
                            label: "Número de WhatsApp",
                            placeholder: "Ej. 3001234567",
                            icon: "phone.fill",
                            iconTint: Color(hex: "16A34A"),
                            keyboardType: .numberPad
                        )
                        .onChange(of: whatsapp) { newValue in
                            // Solo números y máximo 10
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count > 10 {
                                whatsapp = String(filtered.prefix(10))
                            } else if whatsapp != filtered {
                                whatsapp = filtered
                            }
                        }
                        
                        Divider().padding(.vertical, 8)
                        
                        // CAMPO 3: Dirección
                        CustomInputField(
                            value: $address,
                            label: "Dirección",
                            placeholder: "Ej. Calle 5 # 10-20",
                            icon: "mappin.and.ellipse",
                            iconTint: Color(hex: "F97316")
                        )
                        
                        // CAMPO 4: Barrio
                        CustomInputField(
                            value: $neighborhood,
                            label: "Barrio",
                            placeholder: "Ej. Centro Histórico",
                            icon: "signpost.right.fill",
                            iconTint: Color(hex: "F97316")
                        )
                        
                        // CAMPO 5: Detalles
                        CustomInputField(
                            value: $details,
                            label: "Detalles de entrega (Opcional)",
                            placeholder: "Ej. Casa blanca rejas negras, timbre dañado...",
                            icon: "info.circle.fill",
                            iconTint: .gray
                        )
                        
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }
            
            // --- BARRA INFERIOR: BOTÓN GUARDAR ---
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        if isFormValid {
                            // Limpiamos los espacios en blanco sobrantes en los bordes antes de guardar
                            onSaveClick(
                                name.trimmingCharacters(in: .whitespaces),
                                whatsapp,
                                address.trimmingCharacters(in: .whitespaces),
                                neighborhood.trimmingCharacters(in: .whitespaces),
                                details.trimmingCharacters(in: .whitespaces)
                            )
                        }
                    }) {
                        Text("Guardar cambios")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isFormValid ? .white : .gray)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(isFormValid ? Color(hex: "111827") : Color(hex: "E5E7EB"))
                            .cornerRadius(16)
                    }
                    .disabled(!isFormValid)
                }
                .padding(16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Componente Reutilizable: Input Field
struct CustomInputField: View {
    @Binding var value: String
    var label: String
    var placeholder: String
    var icon: String
    var iconTint: Color
    var keyboardType: UIKeyboardType = .default
    
    // Estado para saber si el campo está enfocado y pintar el borde de naranja
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
                .padding(.leading, 4)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconTint)
                    .frame(width: 20)
                
                TextField(placeholder, text: $value)
                    .keyboardType(keyboardType)
                    .focused($isFocused)
                    .foregroundColor(Color(hex: "111827"))
            }
            .padding(16)
            .background(isFocused ? Color.white : Color(hex: "F9FAFB"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? Color(hex: "F97316") : Color(hex: "E5E7EB"), lineWidth: 1)
            )
        }
    }
}
