//
//  AlertContent.swift
//

import SwiftUI

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, macCatalyst 13.0, *)
public extension View {
    @MainActor
    func alertContent<C>(
        isPresented: Bool,
        tint: Color? = nil,
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background(
            Group {
                if isPresented {
                    AlertControllerContent(
                        predicate: {
                            $0.preferredStyle == .alert
                        },
                        tint: tint,
                        fitting: fitting
                    ) {
                        content()
                    }
                }
            }
        )
    }
    
    @MainActor
    func alertContent<T, C>(
        isPresented: Bool,
        presenting data: T?,
        tint: Color? = nil,
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background(
            Group {
                if isPresented, let data {
                    AlertControllerContent(
                        predicate: {
                            $0.preferredStyle == .alert
                        },
                        tint: tint,
                        fitting: fitting
                    ) {
                        content(data)
                    }
                }
            }
        )
    }
    
    @MainActor
    func alertContent<E, C>(
        isPresented: Bool,
        error: E?,
        tint: Color? = nil,
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background(
            Group {
                if isPresented, let error {
                    AlertControllerContent(
                        predicate: {
                            $0.preferredStyle == .alert
                        },
                        tint: tint,
                        fitting: fitting
                    ) {
                        content(error)
                    }
                }
            }
        )
    }
}

#if DEBUG && (os(iOS) || targetEnvironment(macCatalyst))
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var selectedColor: Color = .blue
    @Previewable @State var sliderValue: Double = 0.0
    @Previewable @State var isDoneEnabled: Bool = false
    @Previewable @State var alertTextFieldText: String = ""
    @Previewable @State var date: Date = .now

    HStack {
        ColorPicker("Tint Color", selection: $selectedColor)
            .labelsHidden()
        Button("Show Alert") {
            isPresented.toggle()
        }
        .controlSize(.large)
        .buttonBorderShape(.capsule)
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
            VStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
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
