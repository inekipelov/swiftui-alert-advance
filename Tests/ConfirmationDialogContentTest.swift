#if canImport(UIKit)
import XCTest
import SwiftUI
@testable import AlertAdvance

@available(iOS 15.0, macCatalyst 15.0, *)
@MainActor
final class ConfirmationDialogContentTest: XCTestCase {
    func testContentNotEvaluatedWhenConfirmationDialogNotPresented() {
        let isPresented = false
        var builderInvoked = false

        _ = Text("Host").confirmationDialogContent(isPresented: isPresented) {
            builderInvoked = true
            return Text("Payload")
        }

        XCTAssertFalse(builderInvoked)
    }

    func testContentEvaluatedWhenConfirmationDialogPresented() {
        var builderInvoked = false

        _ = Text("Host").confirmationDialogContent(isPresented: true) {
            builderInvoked = true
            return Text("Payload")
        }

        XCTAssertTrue(builderInvoked)
    }

    func testDataDrivenContentOnlyEvaluatesWhenDataAndPresentationExist() {
        var builderCalls = 0

        _ = Text("Host").confirmationDialogContent(isPresented: false, presenting: "value") { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: true, presenting: Optional<String>.none) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: true, presenting: "value") { _ in
            builderCalls += 1
            return Text("Payload")
        }

        XCTAssertEqual(builderCalls, 1)
    }

    func testErrorDrivenContentOnlyEvaluatesWhenErrorAndPresentationExist() {
        struct SampleError: LocalizedError {}
        var builderCalls = 0

        _ = Text("Host").confirmationDialogContent(isPresented: true, error: Optional<SampleError>.none) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: false, error: SampleError()) { _ in
            builderCalls += 1
            return Text("Payload")
        }
        _ = Text("Host").confirmationDialogContent(isPresented: true, error: SampleError()) { _ in
            builderCalls += 1
            return Text("Payload")
        }

        XCTAssertEqual(builderCalls, 1)
    }
}
#endif
