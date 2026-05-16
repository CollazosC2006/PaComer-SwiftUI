//
//  FilterBottomSheet.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import SwiftUI

// MARK: - Filter Bottom Sheet
struct FilterBottomSheet: View {
    @EnvironmentObject var viewModel: RestaurantMenuViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Cabecera
            HStack {
                Text("Filtros")
                    .font(.title2)
                    .bold()
                Spacer()
                Button("Limpiar") {
                    viewModel.clearFilters()
                }
                .foregroundColor(Color(hex: "F97316"))
            }
            
            // Ordenamiento
            VStack(alignment: .leading, spacing: 12) {
                Text("Ordenar por")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    FilterChip(
                        title: "Menor precio",
                        isSelected: viewModel.sortOrder == .priceAsc,
                        action: { viewModel.sortOrder = .priceAsc }
                    )
                    
                    FilterChip(
                        title: "Mayor precio",
                        isSelected: viewModel.sortOrder == .priceDesc,
                        action: { viewModel.sortOrder = .priceDesc }
                    )
                }
            }
            
            // Rango de Precios
            VStack(alignment: .leading, spacing: 12) {
                Text("Precio máximo")
                    .font(.headline)
                
                HStack {
                    Text("$0")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("$\(Int(viewModel.priceRange.upperBound))")
                        .foregroundColor(.gray)
                }
                
                // Slider nativo de SwiftUI
                Slider(
                    value: Binding(
                        get: { viewModel.priceRange.upperBound },
                        set: { viewModel.priceRange = 0...$0 }
                    ),
                    in: 0...100000,
                    step: 5000
                )
                .accentColor(Color(hex: "F97316"))
            }
            
            Spacer()
            
            // Botón Aplicar
            Button(action: { isPresented = false }) {
                Text("Aplicar filtros")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "111827"))
                    .cornerRadius(16)
            }
        }
        .padding(24)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "F97316") : Color(hex: "F3F4F6"))
                .cornerRadius(20)
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var query: String
    var onFilterClick: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("¿Qué se te antoja hoy?", text: $query)
                .foregroundColor(.black)
            
            Button(action: onFilterClick) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(Color(hex: "F97316"))
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "F3F4F6"), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

// MARK: - Category List
struct CategoryList: View {
    var categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = category == selectedCategory
                    
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isSelected ? .white : Color(hex: "374151"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color(hex: "111827") : Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isSelected ? Color.clear : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Price Info Tooltip
struct PriceInfoTooltip: View {
    var body: some View {
        Text("Los precios que se visualizan son los mismos que ofrece el restaurante en su puesto físico.")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white)
            .lineLimit(nil)
            .padding(12)
            .frame(width: 220)
            .background(Color(hex: "374151"))
            .cornerRadius(16, corners: [.topLeft, .bottomLeft, .bottomRight]) // Ocupa extensión (abajo)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// Extensión para redondear esquinas específicas en SwiftUI
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
