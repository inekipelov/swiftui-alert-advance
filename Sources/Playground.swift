//
//  Playground.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

#if DEBUG && (os(iOS) || targetEnvironment(macCatalyst))
@available(iOS 15.0, macCatalyst 15.0, *)
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

@available(iOS 15.0, macCatalyst 15.0, *)
struct CollapsableRainbowCircle: View {
    @State private var isCollapsed = true
    var body: some View {
        Button(isCollapsed ? "Show" : "Hide") {
            withAnimation {
                isCollapsed.toggle()
            }
        }
        if !isCollapsed {
            RainbowCircle()
                .frame(height: 200)
        }
    }
}

@available(iOS 15.0, macCatalyst 15.0, *)
struct ColoredAlertButton: View {
    let color: Color
    private(set) var fitting: AlertContentFitting = .fitting(vertical: .infinity)
    @State private(set) var isPresented = false
    @State private(set) var sliderValue: Double = 0
    @State private(set) var isEnabled: Bool = false
    @State private(set) var text: String = ""
    
    var body: some View {
        Button("Alert") {
            isPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .tint(color)
        .alert("SwiftUI", isPresented: $isPresented, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
                .disabled(!isEnabled)
            Button("Close", role: .cancel) {}
            TextField("TestField", text: $text)
        }, message: {
            Text("Alert Advance")
        })
        .alertContent(isPresented: isPresented, tint: color, fitting: fitting) {
            VStack {
                Slider(value: $sliderValue, in: 0...100)
                Toggle("Test toggle", isOn: $isEnabled)
                    .tint(color)
                CollapsableRainbowCircle()
            }
            .padding()
        }
    }
}
@available(iOS 15.0, macCatalyst 15.0, *)
struct ColoredConfirmationDialogButton: View {
    let color: Color
    private(set) var fitting: AlertContentFitting = .fitting(vertical: .infinity)
    @State private(set) var isPresented = false
    @State private(set) var sliderValue: Double = 0
    @State private(set) var isEnabled: Bool = true
    
    var body: some View {
        Button("Confirmation") {
            isPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .tint(color)
        .confirmationDialog("SwiftUI", isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button("Done") {}
                .keyboardShortcut(.defaultAction)
            Button("Close", role: .cancel) {}
        }, message: {
            Text("Alert Advance")
        })
        .confirmationDialogContent(isPresented: isPresented, tint: color, fitting: fitting) {
            VStack {
                Slider(value: $sliderValue, in: 0...100)
                Toggle("Test toggle", isOn: $isEnabled)
                    .tint(color)
                CollapsableRainbowCircle()
            }
            .padding()
        }
    }
}

@available(iOS 17.0, macCatalyst 17.0, *)
#Preview {
    @Previewable @State var isDialogPresented: Bool = false
    @Previewable @State var isAlertPresented: Bool = false

    NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                ColoredAlertButton(color: .orange)
                ColoredAlertButton(color: .green)
                ColoredAlertButton(color: .indigo)
                ColoredConfirmationDialogButton(color: .pink)
                ColoredConfirmationDialogButton(color: .purple)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ColoredAlertButton(color: .purple)
                ColoredConfirmationDialogButton(color: .indigo)
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                ColoredAlertButton(color: .orange)
                ColoredConfirmationDialogButton(color: .green)
            }
        }
    }
}
#endif
#endif
