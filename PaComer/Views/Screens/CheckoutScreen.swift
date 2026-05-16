//
//  CheckoutScreen.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

struct CheckoutScreen: View {
    var restaurant: Restaurant
    var onBackClick: () -> Void
    var onConfirmOrder: (String) -> Void
    var onEditDeliveryClick: () -> Void
    
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    
    // Estados para el método de pago
    let paymentOptions = ["Efectivo", "Nequi", "Bre-B"]
    @State private var selectedPayment: String = "Efectivo"
    
    // Estados para el modal de confirmación
    @State private var showConfirmDialog = false
    @State private var countdown = 5
    
    // Temporizador
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    Text("Confirmar Pedido")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Color.clear.frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // --- 1. SECCIÓN: DATOS DE ENTREGA ---
                        HStack {
                            Text("Datos de entrega")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "111827"))
                            Spacer()
                            Button(action: onEditDeliveryClick) {
                                Text("Editar")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "F97316"))
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                        VStack(spacing: 16) {
                            // Nombre
                            DeliveryInfoRow(
                                icon: "person.fill", iconColor: .gray, bgColor: Color(hex: "F3F4F6"),
                                title: "Nombre completo",
                                value: (viewModel.userProfile?.name.isEmpty ?? true) ? "Toca 'Editar'" : viewModel.userProfile!.name
                            )
                            
                            // WhatsApp
                            DeliveryInfoRow(
                                icon: "phone.fill", iconColor: Color(hex: "16A34A"), bgColor: Color(hex: "DCFCE7"),
                                title: "Número de WhatsApp",
                                value: (viewModel.userProfile?.whatsapp.isEmpty ?? true) ? "Sin número" : viewModel.userProfile!.whatsapp
                            )
                            
                            // Dirección
                            let address = viewModel.userProfile?.address ?? ""
                            let neighborhood = viewModel.userProfile?.neighborhood ?? ""
                            let details = viewModel.userProfile?.details ?? ""
                            let fullAddress = address.isEmpty ? "Sin dirección de entrega" : "\(address), \(neighborhood)\(details.isEmpty ? "" : " (\(details))")"
                            
                            DeliveryInfoRow(
                                icon: "mappin.and.ellipse", iconColor: Color(hex: "F97316"), bgColor: Color(hex: "FFF7ED"),
                                title: "Dirección",
                                value: fullAddress
                            )
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(hex: "F3F4F6"), lineWidth: 1))
                        
                        Spacer().frame(height: 24)
                        
                        // --- 2. SECCIÓN: MÉTODO DE PAGO ---
                        Text("Método de pago")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "111827"))
                            .padding(.bottom, 8)
                        
                        Menu {
                            ForEach(paymentOptions, id: \.self) { option in
                                Button(action: { selectedPayment = option }) {
                                    HStack {
                                        Text(option)
                                        if option == selectedPayment {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                HStack {
                                    Image(systemName: "banknote.fill")
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color(hex: "111827"))
                                        .cornerRadius(8)
                                    
                                    Text(selectedPayment)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "111827"))
                                        .padding(.leading, 4)
                                }
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(24)
                            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(hex: "F3F4F6"), lineWidth: 1))
                        }
                        
                        Spacer().frame(height: 16)
                        
                        // INSTRUCCIONES DINÁMICAS DE PAGO
                        let isTransfer = (selectedPayment == "Nequi" || selectedPayment == "Bre-B")
                        let transferAccount = selectedPayment == "Nequi" ? restaurant.accountNumberNequi : restaurant.accountNumberBreb
                        
                        let boxColor = isTransfer ? Color(hex: "F3E8FF") : Color(hex: "DCFCE7")
                        let borderColor = isTransfer ? Color(hex: "D8B4FE") : Color(hex: "86EFAC")
                        let iconColor = isTransfer ? Color(hex: "9333EA") : Color(hex: "16A34A")
                        let textColor = isTransfer ? Color(hex: "581C87") : Color(hex: "14532D")
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: isTransfer ? "building.columns.fill" : "banknote.fill")
                                .foregroundColor(iconColor)
                                .font(.system(size: 20))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(isTransfer ? "Transferencia a \(selectedPayment)" : "Pago Contra Entrega")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(textColor)
                                
                                Text(isTransfer ? "Transfiere al número \(transferAccount).\nPor favor, envía el comprobante al restaurante cuando te contacten por WhatsApp para confirmar el envío." : "El valor de tu pedido será cobrado en efectivo al momento de la entrega. Por favor, ten el dinero listo.")
                                    .font(.system(size: 12))
                                    .foregroundColor(textColor)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(16)
                        .background(boxColor)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(borderColor, lineWidth: 1))
                        
                        Spacer().frame(height: 24)
                        
                        // --- 3. SECCIÓN: RESUMEN ---
                        Text("Resumen (\(viewModel.cartTotalItems) items)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "111827"))
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 16) {
                            let grouped = Dictionary(grouping: viewModel.cartItems) { $0.product }
                            ForEach(grouped.keys.sorted(by: { $0.name < $1.name })) { product in
                                if let variations = grouped[product] {
                                    let groupQty = variations.reduce(0) { $0 + $1.quantity }
                                    let groupPrice = variations.reduce(0.0) { $0 + $1.totalPrice }
                                    
                                    HStack {
                                        HStack {
                                            Text("\(groupQty)x")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color(hex: "F3F4F6"))
                                                .cornerRadius(6)
                                            
                                            Text(product.name)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(hex: "111827"))
                                                .padding(.leading, 4)
                                        }
                                        Spacer()
                                        Text(formatCurrency(groupPrice))
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "111827"))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(hex: "F3F4F6"), lineWidth: 1))
                        
                        Spacer().frame(height: 24)
                        
                        // --- 4. SECCIÓN: BANNER INFORMATIVO ---
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color(hex: "3B82F6"))
                                .font(.system(size: 20))
                            
                            Text("El costo de envío será cotizado por el restaurante. Te notificarán el valor total por WhatsApp para que aceptes o rechaces el pedido. El pago se hará vía \(selectedPayment).")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "1E3A8A"))
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .background(Color(hex: "EFF6FF"))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "DBEAFE"), lineWidth: 1))
                        
                        Spacer().frame(height: 16)
                        
                        // --- 5. SECCIÓN: TOTAL FINAL ---
                        HStack {
                            Text("Total productos")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(Color(hex: "111827"))
                            Spacer()
                            Text(formatCurrency(viewModel.cartTotalPrice))
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(Color(hex: "F97316"))
                        }
                        .padding(.horizontal, 8)
                        
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // --- BARRA INFERIOR DE CONFIRMACIÓN ---
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        countdown = 5
                        showConfirmDialog = true
                    }) {
                        Text("Confirmar Pedido: \(formatCurrency(viewModel.cartTotalPrice))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color(hex: "F97316"))
                            .cornerRadius(16)
                    }
                }
                .padding(16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            }
            
            // --- MODAL DE CONFIRMACIÓN CUSTOM (Replicando AlertDialog) ---
            if showConfirmDialog {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "F59E0B"))
                        
                        Text("¿Estás seguro de tus datos?")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "111827"))
                        
                        Text("Verifica especialmente que tu número de WhatsApp esté correcto, ya que el restaurante se comunicará exclusivamente por ese medio para coordinar el envío.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        
                        Button(action: {
                            showConfirmDialog = false
                            onConfirmOrder(selectedPayment)
                        }) {
                            Text(countdown > 0 ? "Confirmar en \(countdown)" : "Sí, todo está correcto")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(countdown > 0 ? Color(hex: "FDBA74") : Color(hex: "F97316"))
                                .cornerRadius(12)
                        }
                        .disabled(countdown > 0)
                        
                        Button(action: { showConfirmDialog = false }) {
                            Text("Revisar de nuevo")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 40)
                }
                .zIndex(2) // Asegura que se dibuje por encima de todo
                .onReceive(timer) { _ in
                    if showConfirmDialog && countdown > 0 {
                        countdown -= 1
                    }
                }
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

// Subcomponente para las filas de datos de entrega
struct DeliveryInfoRow: View {
    var icon: String
    var iconColor: Color
    var bgColor: Color
    var title: String
    var value: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(bgColor)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "111827"))
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
