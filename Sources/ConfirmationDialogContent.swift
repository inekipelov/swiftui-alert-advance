#if canImport(UIKit)
//
//  ConfirmationDialogContent.swift
//

import SwiftUI
import UIKit

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    @MainActor
    func confirmationDialogContent<C>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background {
            if isPresented.wrappedValue {
                AlertControllerContent(preferredStyle: .actionSheet) {
                    content()
                }
            }
        }
    }
    
    @MainActor
    func confirmationDialogContent<T, C>(
        isPresented: Binding<Bool>,
        presenting data: T?,
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background {
            if isPresented.wrappedValue, let data {
                AlertControllerContent(preferredStyle: .actionSheet) {
                    content(data)
                }
            }
        }
    }
    
    @MainActor
    func confirmationDialogContent<E, C>(
        isPresented: Binding<Bool>,
        error: E?,
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background {
            if isPresented.wrappedValue, let error {
                AlertControllerContent(preferredStyle: .actionSheet) {
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
    
    NavigationStack {
        ZStack {
            Color.black
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem {
                Button("Show Alert") {
                    isPresented.toggle()
                }
                .confirmationDialog("SwiftUI", isPresented: $isPresented, titleVisibility: .visible, actions: {
                    Button("Close") {}
                }, message: {
                    Text("Alert Advance")
                })
                .confirmationDialogContent(isPresented: $isPresented) {
                    Rectangle()
                        .fill(Color.red)
                }
            }
        }
    }
}
#endif
#endif
