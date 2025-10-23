//
//  TitanMartApp.swift
//  TitanMart
//
//  Created by Elizsa Montoya on 10/22/25.
//

import SwiftUI

@main
struct TitanMartApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var cartService = CartService.shared

    // TEMPORARY: Set to true to skip login and test app with mock data
    let skipLoginForDemo = true

    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated || skipLoginForDemo {
                MainTabView()
                    .environmentObject(authService)
                    .environmentObject(cartService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}
