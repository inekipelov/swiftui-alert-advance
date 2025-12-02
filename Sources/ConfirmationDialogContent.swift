//
//  ConfirmationDialogContent.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    @MainActor
    func confirmationDialogContent<C>(
        isPresented: Bool,
        tint: Color? = nil,
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background {
            if isPresented {
                AlertControllerContent(preferredStyle: .actionSheet, tint: tint) {
                    content()
                }
            }
        }
    }
    
    @MainActor
    func confirmationDialogContent<T, C>(
        isPresented: Bool,
        presenting data: T?,
        tint: Color? = nil,
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background {
            if isPresented, let data {
                AlertControllerContent(preferredStyle: .actionSheet, tint: tint) {
                    content(data)
                }
            }
        }
    }
    
    @MainActor
    func confirmationDialogContent<E, C>(
        isPresented: Bool,
        error: E?,
        tint: Color? = nil,
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background {
            if isPresented, let error {
                AlertControllerContent(preferredStyle: .actionSheet, tint: tint) {
                    content(error)
                }
            }
        }
    }
}


#if DEBUG && (os(iOS) || targetEnvironment(macCatalyst))
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var selectedColor: Color = .blue
    @Previewable @State var sliderValue: Double = 0.0
    
    HStack {
        ColorPicker("Tint Color", selection: $selectedColor)
            .labelsHidden()
        Button("Show Alert") {
            isPresented.toggle()
        }
        .controlSize(.large)
        .buttonStyle(.bordered)
        .tint(selectedColor)
        .confirmationDialog("SwiftUI", isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
            Button("Close", role: .cancel) {}
        }, message: {
            Text("Demo Alert Advance")
        })
        .confirmationDialogContent(isPresented: isPresented, tint: selectedColor) {
            Group {
                Slider(value: $sliderValue, in: 0...100)
            }
            .padding(.horizontal)
        }
    }
}
#endif
#endif
