//
//  AlertControllerContent.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

struct AlertControllerContent<Content: View>: UIViewRepresentable {
    private let content: Content
    private let predicate: (UIAlertController) -> Bool
    private let tintColor: Color?
    private let fitting: AlertContentFitting

    init(
        predicate: @escaping (UIAlertController) -> Bool,
        tint: Color? = nil,
        fitting: AlertContentFitting,
        @ViewBuilder content: () -> Content
    ) {
        self.predicate = predicate
        self.content = content()
        self.tintColor = tint
        self.fitting = fitting
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
    func alertController(for uiView: UIView) -> UIAlertController? {
        guard let alertController = uiView.parentViewController?.alertController,
              predicate(alertController) == true
        else {
            return nil
        }
        return alertController
    }
    
    @MainActor
    func embedContentIfPossible(in uiView: UIView) {
        guard
            let alertController = alertController(for: uiView)
        else {
            return
        }
                    
        // Create a hosting controller for our SwiftUI content
        let hosting = fitting.hostingController(rootView: content)
        hosting.view.backgroundColor = .clear
        
        // Place hosting controller as the alert's contentViewController if available
        alertController.contentViewController = hosting
                
        updateLayoutContentIfPossible(in: uiView)
        updateTintColorIfPossible(in: uiView)
    }
    
    @MainActor
    func updateLayoutContentIfPossible(in uiView: UIView) {
        guard
            let alertController = alertController(for: uiView)
        else {
            return
        }
        
        // Ensure the alert sizes to fit the embedded content
        alertController.view.setNeedsLayout()
        alertController.view.layoutIfNeeded()
    }
    
    @MainActor
    func updateTintColorIfPossible(in uiView: UIView) {
        guard
            let alertController = alertController(for: uiView)
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
