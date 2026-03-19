//
//  AlertContentFitting.swift
//

import SwiftUI
#if canImport(UIKit)
import UIKit

public struct AlertContentFitting: Sendable, Hashable {
    private let horizontal: AxisMode
    private let vertical: AxisMode
    
    private init(horizontal: AxisMode, vertical: AxisMode) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public enum AxisMode: Sendable, Hashable {
        case view
        case noIntrinsicMetric
        case layoutFittingCompressed
        case layoutFittingExpanded
        case infinity
        case fixed(CGFloat)
    }
}

public extension AlertContentFitting {
    static let view: Self = .init(horizontal: .view, vertical: .view)
    static let noIntrinsicMetric: Self = .init(horizontal: .noIntrinsicMetric, vertical: .noIntrinsicMetric)
    static let layoutFittingCompressed: Self = .init(horizontal: .layoutFittingCompressed, vertical: .layoutFittingCompressed)
    static let layoutFittingExpanded: Self = .init(horizontal: .layoutFittingExpanded, vertical: .layoutFittingExpanded)
    static let infinity: Self = .init(horizontal: .infinity, vertical: .infinity)
    
    static func fixed(width: CGFloat, height: CGFloat) -> Self { .init(horizontal: .fixed(width), vertical: .fixed(height)) }
    static func fixedHeight(_ height: CGFloat, horizontal: AxisMode = .infinity) -> Self { .init(horizontal: horizontal, vertical: .fixed(height)) }
    static func fixedWidth(_ width: CGFloat, vertical: AxisMode = .infinity) -> Self { .init(horizontal: .fixed(width), vertical: vertical) }
    
    static func fitting(horizontal: AxisMode = .view, vertical: AxisMode) -> Self { .init(horizontal: horizontal, vertical: vertical) }
}

extension AlertContentFitting {
    @MainActor
    func hostingController<Content: View>(rootView: Content) -> UIHostingController<Content> {
        HostingController(rootView: rootView, fitting: self)
    }
}

private extension AlertContentFitting {
    @MainActor
    func size(in uiview: UIView) -> CGSize {
        CGSize(width: width ?? uiview.bounds.width, height: height ?? uiview.bounds.height)
    }
    
    @MainActor
    var width: CGFloat? {
        switch horizontal {
        case .view:
            return nil
        case .noIntrinsicMetric:
            return UIView.noIntrinsicMetric
        case .layoutFittingCompressed:
            return UIView.layoutFittingCompressedSize.width
        case .layoutFittingExpanded:
            return UIView.layoutFittingExpandedSize.width
        case .infinity:
            return .infinity
        case .fixed(let widthValue):
            return widthValue
        }
    }
    
    @MainActor
    var height: CGFloat? {
        switch vertical {
        case .view:
            return nil
        case .noIntrinsicMetric:
            return UIView.noIntrinsicMetric
        case .layoutFittingCompressed:
            return UIView.layoutFittingCompressedSize.height
        case .layoutFittingExpanded:
            return UIView.layoutFittingExpandedSize.height
        case .infinity:
            return .infinity
        case .fixed(let heightValue):
            return heightValue
        }
    }
}

private extension AlertContentFitting {
    @MainActor
    final class HostingController<Content: View>: UIHostingController<Content> {
        private let fitting: AlertContentFitting
        
        init(rootView: Content, fitting: AlertContentFitting) {
            self.fitting = fitting
            super.init(rootView: rootView)
        }
        
        @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            let targetSize = sizeThatFits(in: fitting.size(in: view))
            
            if preferredContentSize != targetSize {
                preferredContentSize = targetSize
                parent?.preferredContentSize = targetSize
            }
        }
    }
}

#endif

