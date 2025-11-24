#if canImport(UIKit)
import XCTest
import SwiftUI
@testable import AlertAdvance

@available(iOS 15.0, *)
@MainActor
final class ConfirmationDialogContentTest: XCTestCase {
    func testContentNotEvaluatedWhenConfirmationDialogNotPresented() {
        var isPresented = false
        var builderInvoked = false
        let binding = Binding<Bool>(get: { isPresented }, set: { isPresented = $0 })

        _ = Text("Host").confirmationDialogContent(isPresented: binding) {
            builderInvoked = true
            return Text("Payload")
        }

        XCTAssertFalse(builderInvoked)
    }

    func testContentEvaluatedWhenConfirmationDialogPresented() {
        var builderInvoked = false

        _ = Text("Host").confirmationDialogContent(isPresented: .constant(true)) {
            builderInvoked = true
            return Text("Payload")
        }

        XCTAssertTrue(builderInvoked)
    }

    func testDataDrivenContentOnlyEvaluatesWhenDataAndPresentationExist() {
        var builderCalls = 0

        _ = Text("Host").confirmationDialogContent(isPresented: .constant(false), presenting: "value") { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: .constant(true), presenting: Optional<String>.none) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: .constant(true), presenting: "value") { _ in
            builderCalls += 1
            return Text("Payload")
        }

        XCTAssertEqual(builderCalls, 1)
    }

    func testErrorDrivenContentOnlyEvaluatesWhenErrorAndPresentationExist() {
        struct SampleError: LocalizedError {}
        var builderCalls = 0

        _ = Text("Host").confirmationDialogContent(isPresented: .constant(true), error: Optional<SampleError>.none) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: .constant(false), error: SampleError()) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: .constant(true), error: SampleError()) { _ in
            builderCalls += 1
            return Text("Payload")
        }

        XCTAssertEqual(builderCalls, 1)
    }
}
#endif
