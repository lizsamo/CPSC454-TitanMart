//
//  ProductViewModel.swift
//  TitanMart
//
//  Created by Elizsa Montoya on 10/22/25.
//

import Foundation

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var selectedCategory: ProductCategory?

    func fetchProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await APIService.shared.fetchProducts(
                category: selectedCategory,
                searchQuery: searchQuery.isEmpty ? nil : searchQuery
            )
        } catch {
            errorMessage = error.localizedDescription
            // For development: Use mock data if API fails
            products = Product.mockProducts
        }

        isLoading = false
    }

    func createProduct(title: String, description: String, price: Double,
                      category: ProductCategory, condition: ProductCondition,
                      imageURLs: [String]) async throws {
        guard let user = AuthService.shared.currentUser,
              let token = AuthService.shared.getToken() else {
            throw APIError.unauthorized
        }

        let product = Product(
            title: title,
            description: description,
            price: price,
            category: category,
            condition: condition,
            imageURLs: imageURLs,
            sellerId: user.id,
            sellerName: user.displayName,
            sellerRating: user.rating
        )

        let createdProduct = try await APIService.shared.createProduct(product, token: token)
        products.insert(createdProduct, at: 0)
    }
}

// MARK: - Mock Data for Development
extension Product {
    static var mockProducts: [Product] {
        [
            Product(
                title: "Calculus Textbook",
                description: "Math 150A textbook in excellent condition. Barely used.",
                price: 45.00,
                category: .textbooks,
                condition: .likeNew,
                imageURLs: [],
                sellerId: "1",
                sellerName: "John Doe",
                sellerRating: 4.8
            ),
            Product(
                title: "iPhone 12",
                description: "Unlocked iPhone 12, 128GB. Works perfectly.",
                price: 400.00,
                category: .electronics,
                condition: .good,
                imageURLs: [],
                sellerId: "2",
                sellerName: "Jane Smith",
                sellerRating: 4.9
            ),
            Product(
                title: "Study Desk",
                description: "Wooden desk perfect for dorm room. Minor scratches.",
                price: 60.00,
                category: .furniture,
                condition: .good,
                imageURLs: [],
                sellerId: "3",
                sellerName: "Mike Johnson",
                sellerRating: 4.5
            ),
            Product(
                title: "CSUF Hoodie",
                description: "Official CSUF hoodie, size medium. Like new!",
                price: 25.00,
                category: .clothing,
                condition: .likeNew,
                imageURLs: [],
                sellerId: "1",
                sellerName: "John Doe",
                sellerRating: 4.8
            ),
            Product(
                title: "MacBook Pro 2019",
                description: "MacBook Pro 13-inch, 256GB SSD, 8GB RAM. Great condition!",
                price: 750.00,
                category: .electronics,
                condition: .good,
                imageURLs: [],
                sellerId: "4",
                sellerName: "Sarah Lee",
                sellerRating: 5.0
            ),
            Product(
                title: "Chemistry Lab Manual",
                description: "Chem 120A lab manual. Never opened, still shrink-wrapped.",
                price: 35.00,
                category: .textbooks,
                condition: .new,
                imageURLs: [],
                sellerId: "2",
                sellerName: "Jane Smith",
                sellerRating: 4.9
            ),
            Product(
                title: "Mini Fridge",
                description: "Perfect for dorm room. 1.6 cubic feet. Works great!",
                price: 80.00,
                category: .furniture,
                condition: .good,
                imageURLs: [],
                sellerId: "5",
                sellerName: "Tom Wilson",
                sellerRating: 4.6
            ),
            Product(
                title: "Graphing Calculator TI-84",
                description: "TI-84 Plus CE in excellent condition. Comes with case.",
                price: 90.00,
                category: .supplies,
                condition: .likeNew,
                imageURLs: [],
                sellerId: "1",
                sellerName: "John Doe",
                sellerRating: 4.8
            ),
            Product(
                title: "Concert Tickets",
                description: "2 tickets to the campus concert this Friday. Can't make it!",
                price: 40.00,
                category: .tickets,
                condition: .new,
                imageURLs: [],
                sellerId: "6",
                sellerName: "Lisa Chen",
                sellerRating: 4.7
            ),
            Product(
                title: "Backpack - North Face",
                description: "Durable backpack with laptop compartment. Lightly used.",
                price: 55.00,
                category: .other,
                condition: .good,
                imageURLs: [],
                sellerId: "3",
                sellerName: "Mike Johnson",
                sellerRating: 4.5
            ),
            Product(
                title: "Economics Textbook",
                description: "ECON 201 textbook. Minimal highlighting, great condition.",
                price: 50.00,
                category: .textbooks,
                condition: .good,
                imageURLs: [],
                sellerId: "4",
                sellerName: "Sarah Lee",
                sellerRating: 5.0
            ),
            Product(
                title: "Gaming Headset",
                description: "SteelSeries Arctis 7 wireless headset. Works perfectly!",
                price: 100.00,
                category: .electronics,
                condition: .likeNew,
                imageURLs: [],
                sellerId: "5",
                sellerName: "Tom Wilson",
                sellerRating: 4.6
            ),
            Product(
                title: "Dorm Chair",
                description: "Comfortable desk chair with wheels. Minor wear on seat.",
                price: 45.00,
                category: .furniture,
                condition: .fair,
                imageURLs: [],
                sellerId: "2",
                sellerName: "Jane Smith",
                sellerRating: 4.9
            ),
            Product(
                title: "Science Goggles",
                description: "Lab safety goggles required for chemistry class. New in box.",
                price: 15.00,
                category: .supplies,
                condition: .new,
                imageURLs: [],
                sellerId: "6",
                sellerName: "Lisa Chen",
                sellerRating: 4.7
            ),
            Product(
                title: "CSUF T-Shirt",
                description: "Official CSUF athletics t-shirt, size large. Never worn.",
                price: 18.00,
                category: .clothing,
                condition: .new,
                imageURLs: [],
                sellerId: "1",
                sellerName: "John Doe",
                sellerRating: 4.8
            )
        ]
    }
}
