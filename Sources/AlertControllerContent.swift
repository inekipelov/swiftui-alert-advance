//
//  AlertControllerContent.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

struct AlertControllerContent<Content: View>: UIViewRepresentable {
    private let content: Content
    private let preferredStyle: UIAlertController.Style

    init(preferredStyle: UIAlertController.Style = .alert, @ViewBuilder _ content: () -> Content) {
        self.preferredStyle = preferredStyle
        self.content = content()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Schedule on next runloop tick using the correct signature.
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            embedContentIfPossible(in: uiView)
        }
    }
    
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
        
        // Ensure the alert sizes to fit the embedded content
        alertController.view.setNeedsLayout()
        alertController.view.layoutIfNeeded()
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