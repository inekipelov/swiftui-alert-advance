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
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> C
    ) -> some View where C: View {
        self.background {
            if isPresented.wrappedValue {
                AlertControllerContent {
                    content()
                }
            }
        }
    }
    
    @MainActor
    func alertContent<T, C>(
        isPresented: Binding<Bool>,
        presenting data: T?,
        @ViewBuilder content: (T) -> C
    ) -> some View where C: View {
        self.background {
            if isPresented.wrappedValue, let data {
                AlertControllerContent {
                    content(data)
                }
            }
        }
    }
    
    @MainActor
    func alertContent<E, C>(
        isPresented: Binding<Bool>,
        error: E?,
        @ViewBuilder content: (E) -> C
    ) -> some View where E : LocalizedError, C : View {
        self.background {
            if isPresented.wrappedValue, let error {
                AlertControllerContent {
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
    
    Button("Show Alert") {
        isPresented.toggle()
    }
    .alert("SwiftUI", isPresented: $isPresented, actions: {
        Button("Close") {}
    }, message: {
        Text("Demo Alert Advance")
    })
    .alertContent(isPresented: $isPresented) {
        Rectangle()
            .fill(Color.red)
    }
}
#endif

#endif
