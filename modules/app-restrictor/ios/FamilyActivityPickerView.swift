//
//  AuthorizationManager.swift
//  AppRestrictor
//
//  Created by Sebastien Bailouni on 2/8/2025.
//

import ExpoModulesCore
import FamilyControls
import ManagedSettings
import SwiftUI

// A generic struct to decode the token JSON from React Native
struct TokenConfiguration: Decodable {
    let token: Data
    let type: String
}

class FamilyActivityPickerView: ExpoView {
    // A property to control the picker's visibility, controlled via state value in RN
    var isPickerPresented = false {
        didSet {
            // When the value changes, update the SwiftUI view's state.
            hostingController.rootView = PickerRootView(
                isPresented: .constant(isPickerPresented),
                selection: hostingController.rootView.selection,
                onSelection: hostingController.rootView.onSelection,
                onDismiss: hostingController.rootView.onDismiss
            )
        }
    }

    // The hosting controller for the SwiftUI view.
    private let hostingController = UIHostingController(
        rootView: PickerRootView(isPresented: .constant(false)))

    // The SwiftUI view that actually contains the picker.
    private var swiftuiView: PickerRootView {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    // The event dispatcher to send data back to React Native.
    let onSelection = EventDispatcher()
    let onDismiss = EventDispatcher()

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        addSubview(hostingController.view)

        // Set up the callback from the SwiftUI view.
        self.swiftuiView.onSelection = { [weak self] selection in
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(selection)
                if let jsonString = String(data: data, encoding: .utf8) {
                    // Dispatch the event with the selection data.
                    self?.onSelection(["selection": jsonString])
                }
            } catch {
                print("Failed to encode selection: \(error)")
            }
        }

        self.swiftuiView.onDismiss = { [weak self] in
            self?.onDismiss([:])
        }
    }

    override func layoutSubviews() {
        hostingController.view.frame = bounds
    }
}

// The root SwiftUI view that contains the .familyActivityPicker modifier.
struct PickerRootView: View {
    // A binding to control the picker's presentation state.
    @Binding var isPresented: Bool

    // The state for the user's selection.
    @State var selection = FamilyActivitySelection()

    // A closure to pass the selection back to the parent ExpoView.
    var onSelection: ((FamilyActivitySelection) -> Void)?
    var onDismiss: (() -> Void)?

    var body: some View {
        // A clear, small view to attach the picker modifier to.
        // It doesn't need to be visible itself.
        Color.clear
            .frame(width: 1, height: 1)
            .familyActivityPicker(
                isPresented: $isPresented, selection: $selection
            )
            .onChange(of: isPresented) { isNowPresented in
                // If the picker was just dismissed...
                if !isNowPresented {
                    // ...and the selection is still empty, it means the user cancelled.
                    if selection.applicationTokens.isEmpty
                        && selection.categoryTokens.isEmpty
                        && selection.webDomains.isEmpty
                    {
                        onDismiss?()
                    }
                }
            }
            .onChange(of: selection) { newSelection in
                // When the selection changes, call the callback.
                onSelection?(newSelection)
            }
    }
}

class ActivityLabelView: ExpoView {
    var tokenJSON: String? {
        didSet {
            updateView()
        }
    }

    private let hostingController = UIHostingController<AnyView>(
        rootView: AnyView(EmptyView()))

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        addSubview(hostingController.view)
    }

    override func layoutSubviews() {
        hostingController.view.frame = bounds
    }

    private func updateView() {
        guard let jsonString = tokenJSON,
            let data = jsonString.data(using: .utf8)
        else {
            hostingController.rootView = AnyView(EmptyView())
            return
        }

        let decoder = JSONDecoder()
        do {
            // Decode the generic token wrapper first to find out the type
            let config = try decoder.decode(TokenConfiguration.self, from: data)

            // Based on the type, decode the specific token and create the label
            switch config.type {
            case "application":
                let appToken = try decoder.decode(
                    ApplicationToken.self, from: config.token)
                if #available(iOS 15.2, *) {
                    hostingController.rootView = AnyView(Label(appToken))
                } else {
                    // Fallback on earlier versions
                }
            case "category":
                let categoryToken = try decoder.decode(
                    ActivityCategoryToken.self, from: config.token)
                if #available(iOS 15.2, *) {
                    hostingController.rootView = AnyView(Label(categoryToken))
                } else {
                    // Fallback on earlier versions
                }
            case "webDomain":
                let webToken = try decoder.decode(
                    WebDomainToken.self, from: config.token)
                if #available(iOS 15.2, *) {
                    hostingController.rootView = AnyView(Label(webToken))
                } else {
                    // Fallback on earlier versions
                }
            default:
                hostingController.rootView = AnyView(EmptyView())
            }
        } catch {
            print("Failed to decode token JSON: \(error)")
            hostingController.rootView = AnyView(EmptyView())
        }
    }
}
