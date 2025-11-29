//
//  Preview.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

#if DEBUG && os(iOS)
struct RainbowCircle: View {
    @State private var color: Color = .black
    
    var body: some View {
        Circle()
            .fill(color)
            .padding()
            .onTapGesture {
                let colors: [Color] = [.green, .indigo, .pink, .orange, .purple]
                let newColor = colors.randomElement() ?? .black
                withAnimation {
                    self.color = newColor
                }
            }
    }
}

struct ColoredAlertButton: View {
    @State private(set) var isPresented = false
    let color: Color
    @State private(set) var sliderValue: Double = 0
    @State private(set) var isEnabled: Bool = false
    
    var body: some View {
        Button("Alert Button") {
            isPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(color)
        .alert("SwiftUI", isPresented: $isPresented, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
            Button("Close", role: .cancel) {}
        }, message: {
            Text("Alert Advance")
        })
        .alertContent(isPresented: isPresented, tint: color) {
            Group {
                Slider(value: $sliderValue, in: 0...100)
                Toggle("Test toggle", isOn: $isEnabled)
                    .tint(color)
            }
            .padding(.horizontal)
        }
    }
}
struct ColoredConfirmationDialogButton: View {
    @State private(set) var isPresented = false
    let color: Color
    @State private(set) var sliderValue: Double = 0
    @State private(set) var isEnabled: Bool = false
    
    var body: some View {
        Button("Confirmation Button") {
            isPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(color)
        .confirmationDialog("SwiftUI", isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
            Button("Close", role: .cancel) {}
        }, message: {
            Text("Alert Advance")
        })
        .confirmationDialogContent(isPresented: isPresented, tint: color) {
            Group {
                Slider(value: $sliderValue, in: 0...100)
                Toggle("Test toggle", isOn: $isEnabled)
                    .tint(color)
            }
            .padding(.horizontal)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isDialogPresented: Bool = false
    @Previewable @State var isAlertPresented: Bool = false

    NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                ColoredAlertButton(color: .orange)
                ColoredConfirmationDialogButton(color: .green)
                ColoredAlertButton(color: .indigo)
                ColoredConfirmationDialogButton(color: .pink)
                ColoredAlertButton(color: .purple)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Confirmation dialog") {
                    isDialogPresented.toggle()
                }
                .confirmationDialog("SwiftUI", isPresented: $isDialogPresented, titleVisibility: .visible, actions: {
                    Button("Done") {}
                        .keyboardShortcut(.defaultAction)
                    Button("Close", role: .cancel) {}
                }, message: {
                    Text("Alert Advance")
                })
                .confirmationDialogContent(isPresented: isDialogPresented) {
                    RainbowCircle()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Alert") {
                    isAlertPresented.toggle()
                }
                .alert("SwiftUI", isPresented: $isAlertPresented, actions: {
                    Button("Done") {}
                        .keyboardShortcut(.defaultAction)
                    Button("Close", role: .cancel) {}
                }, message: {
                    Text("Alert Advance")
                })
                .alertContent(isPresented: isAlertPresented) {
                    RainbowCircle()
                }
            }
        }
    }
}
#endif
#endif
