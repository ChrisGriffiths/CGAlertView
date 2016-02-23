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
    var sut: CGLegacyAlertManager!

    override func setUp() {
        super.setUp()
        sut = CGLegacyAlertManager()
    }

    //MARK: AlertView
    
    func test_createAlertView_returnsUIAlertView_withCorrectDetails() {
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
        let alertView = sut.createAlertView(CGAlertDetails.sampleAlertDetails)
        XCTAssertEqual(alertView.title, "Title")
        XCTAssertEqual(alertView.message, "Message")
        XCTAssertEqual(alertView.numberOfButtons, 3, "Expected 3, got \(alertView.numberOfButtons), should be 1 cancel and 2 actions")
    }

    func test_createActions_returnDictionaryOfActions_whereButtonTitleIsKey() {
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
        let actions = sut.createActions(CGAlertDetails.sampleAlertDetails)
        assertActions(actions, title: "Cancel", closureNil: false)
        assertActions(actions, title: "Action", closureNil: true)
        assertActions(actions, title: "Action1", closureNil: false)
    }

    func test_alertViewButtonPressed_index0_callsCancelAction() {
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Cancel") { callCount += 1 },
            CGAction(title: "Action", action: nil),
        ])

        sut.alertView(sut.alertView!, clickedButtonAtIndex: 0)

        XCTAssertEqual(callCount, 1)
    }

    func test_alertViewButtonPressed_index1_callsTheCorrectAction() {
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Cancel", action: nil),
            CGAction(title: "Action") { callCount += 1 }
        ])

        sut.alertView(sut.alertView!, clickedButtonAtIndex: 1)

        XCTAssertEqual(callCount, 1)
    }

    func test_alertViewButtonPressed_index1_withNilAction_noExceptionThrown() {
        sut.showAlert(CGAlertDetails.sampleAlertDetails, parentViewController:  UIViewController())
        let alertView = sut.createAlertView(CGAlertDetails.sampleAlertDetails)
        sut.alertView(alertView, clickedButtonAtIndex: 1)
        //No expection thrown then this passes
    }
    //Mark: - ActionSheet
    
    func test_createActionSheet_returnsUIActionSheet_withCorrectDetails() {
        let actionSheet = sut.createActionSheet(CGAlertDetails.sampleActionSheetDetails)
        XCTAssertEqual(actionSheet.title, "")
        XCTAssertEqual(actionSheet.numberOfButtons, 4, "Expected 4, got \(actionSheet.numberOfButtons), should be 1 cancel, 1 destructive, and 2 actions")
    }
    
    func test_createActionsWithDestructive_returnDictionaryOfActions_whereButtonTitleIsKey() {
        let actions = sut.createActions(CGAlertDetails.sampleActionSheetDetails)
        assertActions(actions, title: "Cancel", closureNil: false)
        assertActions(actions, title: "Action", closureNil: true)
        assertActions(actions, title: "Action1", closureNil: false)
        assertActions(actions, title: "Destructive", closureNil: false)
    }
    
    func test_actionSheetButtonPressed_index0_callsCancelAction() {
        sut.showActionSheet(CGAlertDetails.sampleActionSheetDetails, parentViewController:  UIViewController(), buttonTextColor: UIColor.blackColor())
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Action", action: nil),
            CGAction(title: "Cancel") { callCount += 1 }
            ])
        
        sut.actionSheet(sut.actionSheet!, clickedButtonAtIndex: 1)
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_actionSheetButtonPressed_index1_callsTheCorrectAction() {
        sut.showActionSheet(CGAlertDetails.sampleActionSheetDetails, parentViewController:  UIViewController(), buttonTextColor: UIColor.blackColor())
        var callCount = 0
        sut.actions = Set([
            CGAction(title: "Cancel", action: nil),
            CGAction(title: "Action") { callCount += 1 }
            ])
        
        sut.actionSheet(sut.actionSheet!, clickedButtonAtIndex: 2)
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_actionSheetButtonPressed_index1_withNilAction_noExceptionThrown() {
        let actionSheet = sut.createActionSheet(CGAlertDetails.sampleActionSheetDetails)
        sut.actionSheet(actionSheet, clickedButtonAtIndex: 1)
        //No expection thrown then this passes
    }

    //MARK: - HELPERS

    func assertActions(actions: Set<CGAction>, title: String, closureNil: Bool) {
        let action = actions.filter { $0.title == title }.first
        XCTAssertEqual(action!.action == nil, closureNil)
    }
}
