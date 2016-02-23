//
//  CGAlertViewTests.swift
//  CGAlertViewTests
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import XCTest
@testable import CGAlertView

class CGAlertControllerTests: XCTestCase {
    var sut: CGAlertController!

    override func setUp() {
        super.setUp()

    }

    func test_showAlert_showsAlertManager_callsAlertViewManager_withDetails() {
        let mockCGAlertControllerManager = MockCGAlertControlManager()
        let parentViewController = UIViewController()

        let sut = CGAlertController(alertControllerManager: mockCGAlertControllerManager)

        sut.showAlert("Title", message: "Message", cancelAction: CGAction(title: "CancelTitle", action: nil), parentViewController: parentViewController)

        XCTAssertEqual(mockCGAlertControllerManager.alertDetails?.title, "Title")
        XCTAssertEqual(mockCGAlertControllerManager.alertDetails?.message, "Message")
        XCTAssertNotNil(mockCGAlertControllerManager.parentViewController)
        XCTAssertTrue(CGAlertController.presentingAlertController! === sut)
    }
    
    func test_showActionSheet_showsActionSheetManager_callsAlertControllerManager_withDetails() {
        let mockCGAlertControllerManager = MockCGAlertControlManager()
        let parentViewController = UIViewController()
        
        let sut = CGAlertController(alertControllerManager: mockCGAlertControllerManager)
        
        sut.showActionSheet("Title", cancelAction: CGAction(title: "CancelTitle", action: nil), destructiveAction: CGAction(title: "DestructiveTitle", action: nil), parentViewController: parentViewController)
        
        XCTAssertEqual(mockCGAlertControllerManager.alertDetails?.title, "Title")
        XCTAssertEqual(mockCGAlertControllerManager.alertDetails?.destructiveAction?.title, "DestructiveTitle")
         XCTAssertEqual(mockCGAlertControllerManager.alertDetails?.cancelAction.title, "CancelTitle")
        XCTAssertNotNil(mockCGAlertControllerManager.parentViewController)
        XCTAssertTrue(CGAlertController.presentingAlertController! === sut)
    }

    class MockCGAlertControlManager: CGAlertControllerManagerProtocol {
        var alertDetails: CGAlertDetails?
        var parentViewController: UIViewController?
        var buttonTextColor: UIColor?

        func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
            self.alertDetails = alertDetails
            self.parentViewController = parentViewController
        }
        
        func showActionSheet(dialogDetails: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?) {
            self.parentViewController = parentViewController
            self.alertDetails = dialogDetails
            self.buttonTextColor = buttonTextColor
        }
    }
}

extension CGAlertDetails {
    static var sampleAlertDetails: CGAlertDetails {
        return CGAlertDetails(
            title: "Title",
            message: "Message",
            cancelAction: CGAction(title: "Cancel") {},
            destructiveAction: nil,
            otherActions: [
                CGAction(title: "Action", action: nil),
                CGAction(title: "Action1") {}
            ]
        )
    }
    
    static var sampleActionSheetDetails: CGAlertDetails {
        return CGAlertDetails(
            title: nil,
            message: nil,
            cancelAction: CGAction(title: "Cancel") {},
            destructiveAction: CGAction(title: "Destructive") {},
            otherActions: [
                CGAction(title: "Action", action: nil),
                CGAction(title: "Action1") {}
            ]
        )
    }
    
}
