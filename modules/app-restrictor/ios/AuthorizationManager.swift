//
//  AuthorizationManager.swift
//  Pods
//
//  Created by Sebastien Bailouni on 2/8/2025.
//

import FamilyControls
import ManagedSettings

class AuthorizationManager: ObservableObject {
    @Published var authorizationStatus: FamilyControls.AuthorizationStatus = .notDetermined
    init() {
        // Check initial status if needed when the app starts
        Task {
            await checkAuthorization()
        }
    }
    func requestAuthorization() async {
        do {
            if #available(iOS 16.0, *) {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } else {
                // TODO: Fallback on earlier versions
            } 
            self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        } catch {
            // Handle errors appropriately (e.g., logging, showing an alert)
            print("Failed to request authorization: \(error)")
            self.authorizationStatus = .denied // Or handle specific errors
        }
    }
    func checkAuthorization() async {
         self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
}
