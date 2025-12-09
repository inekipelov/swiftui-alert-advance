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
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background {
            if isPresented {
                AlertControllerContent(
                    predicate: {
                        $0.preferredStyle == .actionSheet
                    },
                    tint: tint,
                    fitting: fitting
                ) {
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
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background {
            if isPresented, let data {
                AlertControllerContent(
                    predicate: {
                        $0.preferredStyle == .actionSheet
                    },
                    tint: tint,
                    fitting: fitting
                ) {
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
        fitting: AlertContentFitting = .fitting(vertical: .infinity),
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background {
            if isPresented, let error {
                AlertControllerContent(
                    predicate: {
                        $0.preferredStyle == .actionSheet
                    },
                    tint: tint,
                    fitting: fitting
                ) {
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
        .confirmationDialog("SwiftUI", isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
            Button("Close", role: .cancel) {}
        }, message: {
            Text("Demo Alert Advance")
        })
        .confirmationDialogContent(isPresented: isPresented, tint: selectedColor, fitting: .fitting(vertical: .infinity)) {
            VStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                Slider(value: $sliderValue, in: 0...100)
            }
            .padding(.horizontal)
        }
    }
}
#endif
#endif
