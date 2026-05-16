//
//  MockRestaurantRepository.swift
//  PaComer
//
//  Created by Collazos Zambrano, Carlos Daniel on 4/05/26.
//

import Foundation

struct MockRestaurantRepository {

    // Lista de platos quemada en código
    static let mockMenu: [Product] = [
        // ENTRADAS (5)
        Product(id: "d1", name: "Empanaditas de Pipián", description: "Con ají de maní tradicional. Porción de 6 unidades.", price: 8500.0, category: "Entradas", imageUrl: "", extras: [
            Extra(id: "e1", name: "Porción extra de Ají de Maní", price: 1500.0),
            Extra(id: "e2", name: "Limón extra", price: 500.0)
        ]),
        Product(id: "d2", name: "Carantanta", description: "Plato típico a base de hojuela de maíz acompañado de hogao.", price: 15000.0, category: "Entradas", imageUrl: ""),
        Product(id: "d3", name: "Patacones con Hogao", description: "4 patacones pisados crujientes con hogao de la casa.", price: 12000.0, category: "Entradas", imageUrl: ""),
        Product(id: "d4", name: "Arepas de Choclo", description: "Porción de 3 mini arepas dulces con queso cuajada.", price: 10000.0, category: "Entradas", imageUrl: ""),
        Product(id: "d5", name: "Chorizo Caucano", description: "Chorizo ahumado acompañado de arepa blanca y limón.", price: 14500.0, category: "Entradas", imageUrl: ""),

        // PLATOS FUERTES (7)
        Product(id: "d6", name: "Cazuela de Mariscos", description: "Acompañada de arroz con coco y patacones.", price: 32000.0, category: "Platos Fuertes", imageUrl: "", extras: [
            Extra(id: "e3", name: "Extra Patacón (3 und)", price: 2500.0),
            Extra(id: "e4", name: "Porción de Arroz con Coco", price: 4000.0),
            Extra(id: "e5", name: "Queso Parmesano extra", price: 3000.0)
        ]),
        Product(id: "d7", name: "Tamal de Pipián", description: "Masa de maíz añejo relleno de guiso de pipián, carne y tocino.", price: 18000.0, category: "Platos Fuertes", imageUrl: ""),
        Product(id: "d8", name: "Sancocho de Gallina", description: "Sopa tradicional en leña, con arroz, aguacate y ensalada.", price: 28000.0, category: "Platos Fuertes", imageUrl: ""),
        Product(id: "d9", name: "Bandeja Paisa", description: "Frijoles, arroz, chicharrón, carne molida, huevo, tajada y arepa.", price: 35000.0, category: "Platos Fuertes", imageUrl: ""),
        Product(id: "d10", name: "Churrasco", description: "Corte grueso de res a la parrilla, con papas a la francesa y chimichurri.", price: 42000.0, category: "Platos Fuertes", imageUrl: ""),
        Product(id: "d11", name: "Trucha Frita", description: "Trucha fresca frita con patacón y ensalada fresca.", price: 29000.0, category: "Platos Fuertes", imageUrl: ""),
        Product(id: "d12", name: "Pollo a la Plancha", description: "Pechuga de pollo dorada con finas hierbas, arroz y puré.", price: 24000.0, category: "Platos Fuertes", imageUrl: ""),

        // POSTRES (4)
        Product(id: "d13", name: "Desamargado", description: "Dulce tradicional payanés de cáscaras de limón, naranja y brevas.", price: 12000.0, category: "Postres", imageUrl: ""),
        Product(id: "d14", name: "Salpicón Payanés", description: "Mezcla de mora, lulo y guanábana con hielo raspado.", price: 9000.0, category: "Postres", imageUrl: ""),
        Product(id: "d15", name: "Arroz con Leche", description: "Postre casero cremoso con canela y uvas pasas.", price: 8000.0, category: "Postres", imageUrl: ""),
        Product(id: "d16", name: "Brevas con Arequipe", description: "Brevas caladas en almíbar rellenas de dulce de leche.", price: 11000.0, category: "Postres", imageUrl: ""),

        // BEBIDAS (4)
        Product(id: "d17", name: "Champús", description: "Bebida refrescante de maíz, lulo, piña y hojas de naranjo.", price: 7000.0, category: "Bebidas", imageUrl: ""),
        Product(id: "d18", name: "Lulada", description: "Trozos de lulo macerados con limón, azúcar y mucho hielo.", price: 8500.0, category: "Bebidas", imageUrl: ""),
        Product(id: "d19", name: "Jugo de Mora", description: "Jugo natural en agua o en leche.", price: 6000.0, category: "Bebidas", imageUrl: ""),
        Product(id: "d20", name: "Cerveza Artesanal", description: "Cerveza rubia local, muy fría.", price: 12000.0, category: "Bebidas", imageUrl: ""),

        Product(id: "d21", name: "ReCalentado", description: "Arroz con frijoles en Cazerola con un huevo frito, arepa, queso y café", price: 13000.0, category: "Desayunos", imageUrl: "")
    ]

    // Nuestro restaurante de prueba para el MVP
    static func getRestaurantDetails() -> Restaurant {
        return Restaurant(
            id: "r1",
            name: "El Rincón Patojo",
            description: "Comida típica • Antojos tradicionales",
            rating: 4.8,
            deliveryTime: "15-25 min",
            menu: mockMenu,
            accountNumberNequi: "",
            accountNumberBreb: "",
            imageUrl: "",
            whatsappNumber: ""
        )
    }

    static func getRestaurantsList() -> [Restaurant] {
        return [
            Restaurant(
                id: "r1",
                name: "Mora Castilla",
                description: "Comida típica • Antojos tradicionales",
                rating: 4.8,
                deliveryTime: "15-25 min",
                menu: mockMenu, // Reutilizamos el menú
                accountNumberNequi: "3124578900",
                accountNumberBreb: "9876543210",
                imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop",
                whatsappNumber: "3103093418"
            ),
            Restaurant(
                id: "r2",
                name: "Pizzería El Taller",
                description: "Pizzas artesanales • Horno de leña",
                rating: 4.5,
                deliveryTime: "30-45 min",
                menu: [], // Sin menú por ahora
                accountNumberNequi: "3258963012",
                accountNumberBreb: "9876543210",
                imageUrl: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=300&fit=crop",
                whatsappNumber: "3103093418"
            )
        ]
    }
}
