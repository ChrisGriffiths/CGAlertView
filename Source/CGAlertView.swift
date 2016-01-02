//
//  CGAlertView.swift
//  CGAlertView
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import Foundation
import UIKit

public protocol CGAlertViewProtocol {
    func showAlert(title: String, message: String, cancelAction: CGAction, parentViewController: UIViewController)
    func showAlert(dialogDetails: CGAlertDetails, parentViewController: UIViewController)
}

extension CGAlertViewProtocol {
    public func showAlert(title: String, message: String, cancelAction: CGAction, parentViewController: UIViewController) {
        let alertDetails = CGAlertDetails(
            title: title,
            message: message,
            cancelAction: cancelAction,
            otherActions: nil
        )
        self.showAlert(alertDetails, parentViewController: parentViewController)
    }
}

public struct CGAlertDetails {
    public let title: String
    public let message: String
    public let cancelAction: CGAction
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

public class CGAlertView: CGAlertViewProtocol {
    //Used to keep reference alive while alertView showing. Otherwise actions fail
    static internal var presentingAlertView: CGAlertView?

    let alertViewManager: CGAlertViewManagerProtocol

    public convenience init() {
        if #available(iOS 8.0, *) {
            self.init(alertViewManager: CGAlertControlManager())
        } else {
            self.init(alertViewManager: CGAlertViewManager())
        }
    }

    internal init(alertViewManager: CGAlertViewManagerProtocol) {
        self.alertViewManager = alertViewManager
    }

    public func showAlert(dialogDetails: CGAlertDetails, parentViewController: UIViewController) {
        CGAlertView.presentingAlertView = self
        self.alertViewManager.showAlert(dialogDetails, parentViewController: parentViewController)
    }
}

protocol CGAlertViewManagerProtocol {
    func showAlert(_: CGAlertDetails, parentViewController: UIViewController)
}

@objc public class CGAlertViewManager: NSObject, CGAlertViewManagerProtocol {
    internal private(set) var alertView: UIAlertView?
    public internal(set) var actions: Set<CGAction>?

    public func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
        actions = createActions(alertDetails)
        alertView = createAlertView(alertDetails)
        alertView?.show()
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

    func createActions(alertDetails: CGAlertDetails) -> Set<CGAction> {
        var actions: [CGAction] = [
            alertDetails.cancelAction
        ]
        alertDetails.otherActions?.forEach { actions.append($0) }
        return Set(actions)
    }
}

extension CGAlertViewManager: UIAlertViewDelegate {
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex),
            let actions = self.actions else { return }
        let buttonAction = actions.filter { $0.title == buttonTitle }
        buttonAction.first?.action?()
    }
}

@available(iOS 8.0, *)
struct CGAlertControlManager: CGAlertViewManagerProtocol {
    func showAlert(alertDetails: CGAlertDetails, parentViewController: UIViewController) {
        let alertController = self.createAlertView(alertDetails)
        parentViewController.presentViewController(alertController, animated: true, completion:  nil)
    }

    func createAlertView(alertDetails: CGAlertDetails) -> UIAlertController {
        let alert = UIAlertController(
            title: alertDetails.title,
            message: alertDetails.message,
            preferredStyle: .Alert
        )
        var actions = [ createButtonForAction(alertDetails.cancelAction, .Cancel) ]
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
