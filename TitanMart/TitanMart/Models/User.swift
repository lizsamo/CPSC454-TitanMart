//
//  User.swift
//  TitanMart
//
//  Created by Elizsa Montoya on 10/22/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var email: String
    var fullName: String
    var csufEmail: String
    var isEmailVerified: Bool
    var profileImageURL: String?
    var rating: Double
    var totalRatings: Int
    var createdAt: Date

    var displayName: String {
        fullName.isEmpty ? email : fullName
    }

    init(id: String = UUID().uuidString,
         email: String,
         fullName: String = "",
         csufEmail: String,
         isEmailVerified: Bool = false,
         profileImageURL: String? = nil,
         rating: Double = 0.0,
         totalRatings: Int = 0,
         createdAt: Date = Date()) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.csufEmail = csufEmail
        self.isEmailVerified = isEmailVerified
        self.profileImageURL = profileImageURL
        self.rating = rating
        self.totalRatings = totalRatings
        self.createdAt = createdAt
    }
}
