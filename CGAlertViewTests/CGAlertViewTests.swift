//
//  CGAlertViewTests.swift
//  CGAlertViewTests
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import XCTest
@testable import CGAlertView

class CGAlertViewTests: XCTestCase {
    var sut: CGAlertView!

    override func setUp() {
        super.setUp()

    }

    func test_showAlert_showsAlertManager_callsAlertViewManager_withDetails() {
        let mockCGAlertViewManager = MockCGAlertViewManager()
        let parentViewController = UIViewController()

        let sut = CGAlertView(alertViewManager: mockCGAlertViewManager)

        sut.showAlert("Title", message: "Message", cancelAction: CGAction(title: "CancelTitle", action: nil), parentViewController: parentViewController)
        XCTAssertEqual(mockCGAlertViewManager.alertDetails?.title, "Title")
        XCTAssertEqual(mockCGAlertViewManager.alertDetails?.message, "Message")
        XCTAssertNotNil(mockCGAlertViewManager.parentViewController)
    }

    class MockCGAlertViewManager: CGAlertViewManagerProtocol {
        var alertDetails: CGAlertDetails?
        var parentViewController: UIViewController?

        func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
            self.alertDetails = alertDetails
            self.parentViewController = parentViewController
        }
    }
}

extension CGAlertDetails {
    static var sampleAlertDetails: CGAlertDetails {
        return CGAlertDetails(
            title: "Title",
            message: "Message",
            cancelAction: CGAction(title: "Cancel") {},
            otherActions: [
                CGAction(title: "Action", action: nil),
                CGAction(title: "Action1") {}
            ]
        )
    }
}
