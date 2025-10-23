//
//  Order.swift
//  TitanMart
//
//  Created by Elizsa Montoya on 10/22/25.
//

import Foundation

enum OrderStatus: String, Codable {
    case pending = "Pending"
    case paymentProcessing = "Payment Processing"
    case confirmed = "Confirmed"
    case meetingScheduled = "Meeting Scheduled"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Order: Identifiable, Codable {
    let id: String
    var items: [CartItem]
    var buyerId: String
    var buyerName: String
    var sellerId: String
    var sellerName: String
    var totalAmount: Double
    var status: OrderStatus
    var paymentIntentId: String?
    var createdAt: Date
    var updatedAt: Date
    var meetingLocation: String?
    var meetingTime: Date?

    init(id: String = UUID().uuidString,
         items: [CartItem],
         buyerId: String,
         buyerName: String,
         sellerId: String,
         sellerName: String,
         totalAmount: Double,
         status: OrderStatus = .pending,
         paymentIntentId: String? = nil,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         meetingLocation: String? = nil,
         meetingTime: Date? = nil) {
        self.id = id
        self.items = items
        self.buyerId = buyerId
        self.buyerName = buyerName
        self.sellerId = sellerId
        self.sellerName = sellerName
        self.totalAmount = totalAmount
        self.status = status
        self.paymentIntentId = paymentIntentId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.meetingLocation = meetingLocation
        self.meetingTime = meetingTime
    }
}
