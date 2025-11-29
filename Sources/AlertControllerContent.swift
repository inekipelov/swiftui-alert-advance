//
//  AlertControllerContent.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

struct AlertControllerContent<Content: View>: UIViewRepresentable {
    private let content: Content
    private let preferredStyle: UIAlertController.Style
    private let tintColor: Color?

    init(preferredStyle: UIAlertController.Style = .alert, tint: Color? = nil, @ViewBuilder content: () -> Content) {
        self.preferredStyle = preferredStyle
        self.content = content()
        self.tintColor = tint
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            embedContentIfPossible(in: view)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            updateLayoutContentIfPossible(in: uiView)
        }
    }
}

private extension AlertControllerContent {
    @MainActor
    func embedContentIfPossible(in uiView: UIView) {
        guard
            let alertController = uiView.parentViewController?.alertController,
            alertController.preferredStyle == preferredStyle
        else {
            return
        }
                    
        // Create a hosting controller for our SwiftUI content
        let hosting = UIHostingController(rootView: content)
        hosting.view.backgroundColor = .clear
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Place hosting controller as the alert's contentViewController if available
        alertController.contentViewController = hosting
                
        updateLayoutContentIfPossible(in: uiView)
        
        updateTintColorIfPossible(in: uiView)
    }
    
    @MainActor
    func updateLayoutContentIfPossible(in uiView: UIView) {
        guard
            let alertController = uiView.parentViewController?.alertController,
            alertController.preferredStyle == preferredStyle
        else {
            return
        }
        
        // Ensure the alert sizes to fit the embedded content
        alertController.view.setNeedsLayout()
        alertController.view.layoutIfNeeded()
        
        if let preferredContentSize = alertController.contentViewController?.preferredContentSize {
            alertController.preferredContentSize.height = preferredContentSize.height
        }
    }
    
    @MainActor
    func updateTintColorIfPossible(in uiView: UIView) {
        guard
            let alertController = uiView.parentViewController?.alertController,
            alertController.preferredStyle == preferredStyle
        else {
            return
        }
        
        if let tintColor {
            alertController.view.tintColor = UIColor(tintColor)
        }
    }
}

private extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let viewController = next as? UIViewController {
                return viewController
            }
            responder = next
        }
        return nil
    }
}

private extension UIViewController {
    var alertController: UIAlertController? {
        if let alert = self as? UIAlertController {
            return alert
        }
        if let alert = presentedViewController as? UIAlertController {
            return alert
        }
        
        return presentingViewController?.alertController
    }
}

private extension UIAlertController {
    var contentViewController: UIViewController? {
        get { return value(forKey: "contentViewController") as? UIViewController }
        set { setValue(newValue, forKey: "contentViewController") }
    }
}

#endif
