//
//  APIService.swift
//  TitanMart
//
//  Created by Elizsa Montoya on 10/22/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
    case unauthorized

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
}

class APIService {
    static let shared = APIService()

    // TODO: Replace with your actual AWS API Gateway endpoint
    private let baseURL = "https://your-api-gateway-url.amazonaws.com/prod"

    private init() {}

    // MARK: - Generic Request Method
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = errorMessage["message"] {
                    throw APIError.serverError(message)
                }
                throw APIError.serverError("Status code: \(httpResponse.statusCode)")
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Authentication
    func register(email: String, password: String, csufEmail: String, fullName: String) async throws -> User {
        let body = [
            "email": email,
            "password": password,
            "csufEmail": csufEmail,
            "fullName": fullName
        ]
        let jsonData = try JSONEncoder().encode(body)
        return try await request(endpoint: "/auth/register", method: "POST", body: jsonData)
    }

    func login(email: String, password: String) async throws -> (user: User, token: String) {
        struct LoginResponse: Decodable {
            let user: User
            let token: String
        }

        let body = ["email": email, "password": password]
        let jsonData = try JSONEncoder().encode(body)
        let response: LoginResponse = try await request(endpoint: "/auth/login", method: "POST", body: jsonData)
        return (user: response.user, token: response.token)
    }

    func verifyEmail(code: String, userId: String) async throws -> User {
        let body = ["code": code, "userId": userId]
        let jsonData = try JSONEncoder().encode(body)
        return try await request(endpoint: "/auth/verify-email", method: "POST", body: jsonData)
    }

    // MARK: - Products
    func fetchProducts(category: ProductCategory? = nil, searchQuery: String? = nil) async throws -> [Product] {
        var endpoint = "/products"
        var queryItems: [String] = []

        if let category = category {
            queryItems.append("category=\(category.rawValue)")
        }
        if let query = searchQuery, !query.isEmpty {
            queryItems.append("search=\(query)")
        }

        if !queryItems.isEmpty {
            endpoint += "?" + queryItems.joined(separator: "&")
        }

        return try await request(endpoint: endpoint)
    }

    func createProduct(_ product: Product, token: String) async throws -> Product {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(product)
        return try await request(endpoint: "/products", method: "POST", body: jsonData, token: token)
    }

    // MARK: - Orders
    func createOrder(_ order: Order, token: String) async throws -> Order {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(order)
        return try await request(endpoint: "/orders", method: "POST", body: jsonData, token: token)
    }

    func fetchOrders(userId: String, token: String) async throws -> [Order] {
        return try await request(endpoint: "/orders/user/\(userId)", token: token)
    }

    // MARK: - Reviews
    func createReview(_ review: Review, token: String) async throws -> Review {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(review)
        return try await request(endpoint: "/reviews", method: "POST", body: jsonData, token: token)
    }

    func fetchReviews(userId: String) async throws -> [Review] {
        return try await request(endpoint: "/reviews/user/\(userId)")
    }

    // MARK: - Payment
    func createPaymentIntent(amount: Double, orderId: String, token: String) async throws -> String {
        let body = ["amount": amount, "orderId": orderId] as [String : Any]
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let response: [String: String] = try await request(endpoint: "/payment/create-intent", method: "POST", body: jsonData, token: token)
        guard let clientSecret = response["clientSecret"] else {
            throw APIError.serverError("No client secret returned")
        }
        return clientSecret
    }
}
