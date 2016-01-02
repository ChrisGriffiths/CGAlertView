//
//  CGAlertControlManagerTests.swift
//  CGAlertView
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import XCTest
@testable import CGAlertView

class CGAlertControlManagerTests: XCTestCase {
    var sut: CGAlertControlManager!

    override func setUp() {
        super.setUp()
        sut = CGAlertControlManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createAlertView_returnsUIAlertView_withCorrectDetails() {
        let alertView = sut.createAlertView(CGAlertDetails.sampleAlertDetails)
        XCTAssertEqual(alertView.title, "Title")
        XCTAssertEqual(alertView.message, "Message")
        XCTAssertEqual(alertView.actions.count, 3)
    }

    func test_createOtherButton_withIndex_addActionsToAlertController() {
//        let alertController = UIAlertController()
//        sut.createOtherButton(2, otherButtonTitle: "TITLE", alertView: alertController)
//
//        XCTAssertEqual(alertController.actions.count, 1)
    }

    func test_createOtherButton_withIndex_greaterThanOtherButtonActions_noExpectionThrow() {
//        sut.createOtherButton(2, otherButtonTitle: "TITLE", alertView: UIAlertController())
        //No expection thrown then this passes
    }
}
