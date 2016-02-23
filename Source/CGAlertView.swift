//
//  CGAlertView.swift
//  CGAlertView
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import Foundation
import UIKit

public protocol CGAlertControllerProtocol {
    func showAlert(title: String, message: String, cancelAction: CGAction, parentViewController: UIViewController)
    func showActionSheet(title: String, cancelAction: CGAction, destructiveAction: CGAction, parentViewController: UIViewController)
    func showAlert(dialogDetails: CGAlertDetails, parentViewController: UIViewController)
    func showActionSheet(dialogDetails: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?)
    func showActionSheet(dialogDetails: CGAlertDetails, parentViewController: UIViewController)

}

extension CGAlertControllerProtocol {
    public func showAlert(title: String, message: String, cancelAction: CGAction, parentViewController: UIViewController) {
        let alertDetails = CGAlertDetails(
            title: title,
            message: message,
            cancelAction: cancelAction,
            destructiveAction: nil,
            otherActions: nil
        )
        self.showAlert(alertDetails, parentViewController: parentViewController)
    }
    
    public func showActionSheet(title: String, cancelAction: CGAction, destructiveAction: CGAction, parentViewController: UIViewController) {
        let actionSheetDetails = CGAlertDetails(
            title: title,
            message: nil,
            cancelAction: cancelAction,
            destructiveAction: destructiveAction,
            otherActions: nil
        )
        self.showActionSheet(actionSheetDetails, parentViewController: parentViewController)
    }
    public func showActionSheet(dialogDetails: CGAlertDetails, parentViewController: UIViewController) {
        showActionSheet(dialogDetails, parentViewController: parentViewController, buttonTextColor: nil)
    }
}

public struct CGAlertDetails {
    public let title: String?
    public let message: String?
    public let cancelAction: CGAction
    public let destructiveAction: CGAction?
    public let otherActions: [CGAction]?
}

extension CGAlertDetails: Equatable {
}

public func ==(lhs: CGAlertDetails, rhs: CGAlertDetails) -> Bool {
    return lhs.title == rhs.title
}

public struct CGAction {
    public let title: String
    public let action: (() -> Void)?
}

extension CGAction: Hashable {
    public var hashValue: Int {
        return self.title.hashValue
    }
}

extension CGAction: Equatable {
}

public func ==(lhs: CGAction, rhs: CGAction) -> Bool {
    return lhs.title == rhs.title
}

public class CGAlertController: CGAlertControllerProtocol {
    //Used to keep reference alive while CGAlertController showing. Otherwise actions fail
    static internal var presentingAlertController: CGAlertController?

    let alertControllerManager: CGAlertControllerManagerProtocol

    public init() {
        if #available(iOS 8.0, *) {
            self.alertControllerManager = CGAlertControlManager()
        } else {
            self.alertControllerManager = CGLegacyAlertManager()
        }
    }

    internal init(alertControllerManager: CGAlertControllerManagerProtocol) {
        self.alertControllerManager = alertControllerManager
    }

    public func showAlert(dialogDetails: CGAlertDetails, parentViewController: UIViewController) {
        CGAlertController.presentingAlertController = self
        self.alertControllerManager.showAlert(dialogDetails, parentViewController: parentViewController)
    }
    
    public func showActionSheet(dialogDetails: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?) {
        CGAlertController.presentingAlertController = self
        self.alertControllerManager.showActionSheet(dialogDetails, parentViewController: parentViewController, buttonTextColor: buttonTextColor)
    }

}

protocol CGAlertControllerManagerProtocol {
    func showAlert(_: CGAlertDetails, parentViewController: UIViewController)
    func showActionSheet(_: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?)
}

@objc public class CGLegacyAlertManager: NSObject, CGAlertControllerManagerProtocol {
    internal private(set) var alertView: UIAlertView?
    internal private(set) var actionSheet: UIActionSheet?
    public internal(set) var actions: Set<CGAction>?
    var buttonTextColor: UIColor?

    public func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
        actions = createActions(alertDetails)
        alertView = createAlertView(alertDetails)
        alertView?.show()
    }
    
    public func showActionSheet(actionSheetDetails: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?) {
        self.buttonTextColor = buttonTextColor
        actions = createActions(actionSheetDetails)
        actionSheet = createActionSheet(actionSheetDetails)
        actionSheet?.showInView(parentViewController.view)
    }


    func createAlertView(alertDetails: CGAlertDetails) -> UIAlertView {
        let alert = UIAlertView(
            title: alertDetails.title,
            message: alertDetails.message,
            delegate: self,
            cancelButtonTitle: alertDetails.cancelAction.title
        )

        alertDetails.otherActions?.forEach { action in
            alert.addButtonWithTitle(action.title)
        }
        
        return alert
    }
    
    func createActionSheet(actionSheetDetails: CGAlertDetails) -> UIActionSheet {
        let actionSheet = UIActionSheet(
            title: actionSheetDetails.title,
            delegate: self,
            cancelButtonTitle: actionSheetDetails.cancelAction.title,
            destructiveButtonTitle: actionSheetDetails.destructiveAction?.title
        )
        
        actionSheetDetails.otherActions?.forEach { action in
            actionSheet.addButtonWithTitle(action.title)
        }
        
        return actionSheet
    }

    func createActions(alertDetails: CGAlertDetails) -> Set<CGAction> {
        var actions: [CGAction] = [ alertDetails.cancelAction ]
        if let destructiveAction = alertDetails.destructiveAction {
            actions.append(destructiveAction)
        }
        alertDetails.otherActions?.forEach { actions.append($0) }
        return Set(actions)
    }
}

extension CGLegacyAlertManager: UIAlertViewDelegate, UIActionSheetDelegate {
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        performActionWithButtonTitle(buttonTitle)
    }
    
    public func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = actionSheet.buttonTitleAtIndex(buttonIndex)
        performActionWithButtonTitle(buttonTitle)
    }
    
    func performActionWithButtonTitle(buttonTitle: String?) {
        guard let actions = self.actions, let title = buttonTitle else { return }
        let buttonAction = actions.filter { $0.title == title }
        buttonAction.first?.action?()
    }
    
    public func willPresentActionSheet(actionSheet: UIActionSheet) {
        guard let color = buttonTextColor else { return }
        for button in actionSheet.subviews where button is UIButton {
            (button as! UIButton).setTitleColor(color, forState: .Normal)
        }
    }
}

@available(iOS 8.0, *)
struct CGAlertControlManager: CGAlertControllerManagerProtocol {
    
    func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
        let alertController = self.createAlertView(alertDetails, preferredStyle: .Alert)
        parentViewController.presentViewController(alertController, animated: true, completion:  nil)
    }
    func showActionSheet(alertDetails: CGAlertDetails, parentViewController: UIViewController, buttonTextColor: UIColor?) {
        let alertController = self.createAlertView(alertDetails, preferredStyle: .ActionSheet)
        if let color = buttonTextColor {
            alertController.view.tintColor = color
        }
        parentViewController.presentViewController(alertController, animated: true, completion:  nil)
    }

    func createAlertView(alertDetails: CGAlertDetails, preferredStyle: UIAlertControllerStyle) -> UIAlertController {
        let alert = UIAlertController(
            title: alertDetails.title,
            message: alertDetails.message,
            preferredStyle: preferredStyle
        )
        
        var actions = [ createButtonForAction(alertDetails.cancelAction, .Cancel) ]
        if let destructiveAction = alertDetails.destructiveAction {
            actions.append(createButtonForAction(destructiveAction, .Destructive))
        }
        
        alertDetails.otherActions?.forEach { actions.append(createButtonForAction($0, .Default)) }
        actions.forEach { alert.addAction($0) }

        return alert
    }

    func createButtonForAction(action: CGAction, _ style: UIAlertActionStyle) -> UIAlertAction {
        return UIAlertAction(title: action.title, style: style) {  alertAction in
            action.action?()
        }
    }
}
