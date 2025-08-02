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

class FamilyActivityPickerView: ExpoView {
    // A property to control the picker's visibility, controlled via state value in RN
    var isPickerPresented = false {
        didSet {
            // When the value changes, update the SwiftUI view's state.
            swiftuiView.isPresented = isPickerPresented
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
    @State private var selection = FamilyActivitySelection()

    // A closure to pass the selection back to the parent ExpoView.
    var onSelection: ((FamilyActivitySelection) -> Void)?

    var body: some View {
        // A clear, small view to attach the picker modifier to.
        // It doesn't need to be visible itself.
        Color.clear
            .frame(width: 1, height: 1)
            .familyActivityPicker(
                isPresented: $isPresented, selection: $selection
            )
            .onChange(of: selection) { newSelection in
                // When the selection changes, call the callback.
                onSelection?(newSelection)
            }
    }
}
