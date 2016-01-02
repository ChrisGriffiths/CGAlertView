//
//  CGAlertViewManagerTests.swift
//  CGAlertView
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import XCTest
@testable import CGAlertView

class CGAlertViewManagerTests: XCTestCase {
    var sut: CGAlertViewManager!

    override func setUp() {
        super.setUp()
        sut = CGAlertViewManager()
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
    }

    func test_createAlertView_returnsUIAlertView_withCorrectDetails() {
        let alertView = sut.createAlertView(CGAlertDetails.sampleAlertDetails)
        XCTAssertEqual(alertView.title, "Title")
        XCTAssertEqual(alertView.message, "Message")
        XCTAssertEqual(alertView.numberOfButtons, 3, "Expected 3, got \(alertView.numberOfButtons), should be 1 cancel and 2 actions")
    }

    func test_createActions_returnDictionaryOfActions_whereButtonTitleIsKey() {
        let actions = sut.createActions(CGAlertDetails.sampleAlertDetails)
        assetActions(actions, title: "Cancel", closureNil: false)
        assetActions(actions, title: "Action", closureNil: true)
        assetActions(actions, title: "Action1", closureNil: false)
    }

    func test_alertViewButtonPressed_index0_callsCancelAction() {
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Cancel") { callCount += 1 },
            CGAction(title: "Action", action: nil),
        ])

        sut.alertView(sut.alertView!, clickedButtonAtIndex: 0)

        XCTAssertEqual(callCount, 1)
    }

    func test_alertViewButtonPressed_index1_callsTheCorrectAction() {
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Cancel", action: nil),
            CGAction(title: "Action") { callCount += 1 }
        ])

        sut.alertView(sut.alertView!, clickedButtonAtIndex: 1)

        XCTAssertEqual(callCount, 1)
    }

    func test_alertViewButtonPressed_index1_withNilAction_noExceptionThrown() {
        let alertView = sut.createAlertView(CGAlertDetails.sampleAlertDetails)
        sut.alertView(alertView, clickedButtonAtIndex: 1)
        //No expection thrown then this passes
    }

    //MARK: - HELPERS

    func assetActions(actions: Set<CGAction>, title: String, closureNil: Bool) {
        let action = actions.filter { $0.title == title }.first
        XCTAssertEqual(action!.action == nil, closureNil)
    }
}
