//
//  AlertContent.swift
//

import SwiftUI

#if canImport(UIKit)
import UIKit

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    @MainActor
    func alertContent<C>(
        isPresented: Bool,
        tint: Color? = nil,
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background {
            if isPresented {
                AlertControllerContent(preferredStyle: .alert, tint: tint) {
                    content()
                }
            }
        }
    }
    
    @MainActor
    func alertContent<T, C>(
        isPresented: Bool,
        presenting data: T?,
        tint: Color? = nil,
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background {
            if isPresented, let data {
                AlertControllerContent(preferredStyle: .alert, tint: tint) {
                    content(data)
                }
            }
        }
    }
    
    @MainActor
    func alertContent<E, C>(
        isPresented: Bool,
        error: E?,
        tint: Color? = nil,
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background {
            if isPresented, let error {
                AlertControllerContent(preferredStyle: .alert, tint: tint) {
                    content(error)
                }
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var selectedColor: Color = .blue
    @Previewable @State var sliderValue: Double = 0.0
    @Previewable @State var isDoneEnabled: Bool = false
    @Previewable @State var alertTextFieldText: String = ""

    HStack {
        ColorPicker("Tint Color", selection: $selectedColor)
            .labelsHidden()
        Button("Show Alert") {
            isPresented.toggle()
        }
        .controlSize(.large)
        .buttonStyle(.bordered)
        .tint(selectedColor)
        .shadow(radius: 0.2)
        .alert("SwiftUI", isPresented: $isPresented, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
                .disabled(!isDoneEnabled)
            Button("Close", role: .cancel) {}
            TextField("Field", text: $alertTextFieldText)
        }, message: {
            Text("Demo Alert Advance")
        })
        .alertContent(isPresented: isPresented, tint: selectedColor) {
            Group {
                Slider(value: $sliderValue, in: 0...100)
                Toggle("Enable Done", isOn: $isDoneEnabled)
                    .tint(selectedColor)
            }
            .padding(.horizontal)
        }
    }
}
#endif
#endif
