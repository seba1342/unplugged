//
//  AuthorizationManager.swift
//  AppRestrictor
//
//  Created by Sebastien Bailouni on 2/8/2025.
//

import ExpoModulesCore

// See https://docs.expo.dev/modules/module-api for more details about available components.
public class AppRestrictorModule: Module {
    public func definition() -> ModuleDefinition {
        Name("AppRestrictor")

        AsyncFunction("requestAuthorization") { (promise: Promise) in
            var authManager = AuthorizationManager()

            switch authManager.authorizationStatus {
            case .notDetermined:
                Task {
                    do {
                        if #available(iOS 16.0, *) {
                            await authManager.requestAuthorization()
                        } else {
                            // TODO: Fallback on earlier versions
                        }

                        promise.resolve(
                            "AppRestrictor::requestAuthorization - approved")
                    }
                }
            case .denied:
                promise.resolve("AppRestrictor:requestAuthorization - denied")
            case .approved:
                promise.resolve(
                    "AppRestrictor::requestAuthorization - approved")
            @unknown default:
                promise.reject(
                    "E_UNKNOWN_STATUS", "Unknown authorization status")
            }

        }

        AsyncFunction("authorizationStatus") { (promise: Promise) in
            var authManager = AuthorizationManager()

            switch authManager.authorizationStatus {
            case .notDetermined:
                promise.resolve(
                    "AppRestrictor::requestAuthorization - notDetermined")
            case .denied:
                promise.resolve("AppRestrictor:requestAuthorization - denied")
            case .approved:
                promise.resolve(
                    "AppRestrictor::requestAuthorization - approved")
            @unknown default:
                promise.reject(
                    "E_UNKNOWN_STATUS", "Unknown authorization status")
            }
        }

        // Defines the native view component that renders the app picker
        View(FamilyActivityPickerView.self) {
            // This prop will be used to show or hide the picker from JS.
            Prop("isPickerPresented") {
                (view: FamilyActivityPickerView, isPresented: Bool) in
                view.isPickerPresented = isPresented
            }

            // This defines the event that will be sent from the native view to JS
            Events("onSelection")
        }
    }
}
