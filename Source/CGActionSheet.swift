//
//  CGActionSheet.swift
//  CGactionSheet
//
//  Created by Chris Mitchelmore on 23/02/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import Foundation


import Foundation
import UIKit

public protocol CGActionSheetProtocol {
//    func showActionSheet(cancelAction: CGAction, parentViewController: UIViewController)

    func showActionSheet(actionSheetDetails: CGActionSheetDetails, parentViewController: UIViewController)
}

extension CGActionSheetProtocol {
    public func showActionSheet(title: String, cancelAction: CGAction, destructiveAction: CGAction, parentViewController: UIViewController) {
        let actionSheetDetails = CGActionSheetDetails(
            title: title,
            cancelAction: cancelAction,
            destructiveAction: destructiveAction,
            otherActions: nil
        )
        self.showActionSheet(actionSheetDetails, parentViewController: parentViewController)
    }
}

public struct CGActionSheetDetails {
    public let title: String
    public let cancelAction: CGAction
    public let destructiveAction: CGAction
    public let otherActions: [CGAction]?
}

extension CGActionSheetDetails: Equatable {
}

public func ==(lhs: CGActionSheetDetails, rhs: CGActionSheetDetails) -> Bool {
    return lhs.title == rhs.title
}

public class CGActionSheet: CGActionSheetProtocol {
    //Used to keep reference alive while actionSheet showing. Otherwise actions fail
    static internal var presentingactionSheet: CGActionSheet?
    
    let actionSheetManager: CGActionSheetManagerProtocol
    
    public init() {
        if #available(iOS 8.0, *) {
            self.actionSheetManager = CGActionSheetControlManager()
        } else {
            self.actionSheetManager = CGActionSheetManager()
        }
    }
    
    internal init(actionSheetManager: CGActionSheetManagerProtocol) {
        self.actionSheetManager = actionSheetManager
    }
    
    public func showActionSheet(actionSheetDetails: CGActionSheetDetails, parentViewController: UIViewController) {
        CGActionSheet.presentingactionSheet = self
        self.actionSheetManager.showActionSheet(actionSheetDetails, parentViewController: parentViewController)
    }
}

protocol CGActionSheetManagerProtocol {
    func showActionSheet(_: CGActionSheetDetails, parentViewController: UIViewController)
}

@objc public class CGActionSheetManager: NSObject, CGActionSheetManagerProtocol {
    internal private(set) var actionSheet: UIActionSheet?
    public internal(set) var actions: Set<CGAction>?
    
    public func showActionSheet(actionSheetDetails: CGActionSheetDetails, parentViewController: UIViewController) {
        actions = createActions(actionSheetDetails)
        actionSheet = createActionSheet(actionSheetDetails)
        actionSheet?.showInView(parentViewController.view)
    }
    
    func createActionSheet(actionSheetDetails: CGActionSheetDetails) -> UIActionSheet {
        let actionSheet = UIActionSheet(
            title: actionSheetDetails.title,
            delegate: self,
            cancelButtonTitle: actionSheetDetails.cancelAction.title,
            destructiveButtonTitle: actionSheetDetails.destructiveAction.title
        )
        
        actionSheetDetails.otherActions?.forEach { action in
            actionSheet.addButtonWithTitle(action.title)
        }
        
        return actionSheet
    }
    
    func createActions(actionSheetDetails: CGActionSheetDetails) -> Set<CGAction> {
        var actions: [CGAction] = [
            actionSheetDetails.cancelAction
        ]
        actionSheetDetails.otherActions?.forEach { actions.append($0) }
        return Set(actions)
    }
}

extension CGActionSheetManager: UIActionSheetDelegate {
    public func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        guard let buttonTitle = actionSheet.buttonTitleAtIndex(buttonIndex),
            let actions = self.actions else { return }
        let buttonAction = actions.filter { $0.title == buttonTitle }
        buttonAction.first?.action?()
    }
}

@available(iOS 8.0, *)
struct CGActionSheetControlManager: CGActionSheetManagerProtocol {
    func showActionSheet(actionSheetDetails: CGActionSheetDetails, parentViewController: UIViewController) {
        let actionSheetController = self.createactionSheet(actionSheetDetails)
        parentViewController.presentViewController(actionSheetController, animated: true, completion:  nil)
    }
    
    func createactionSheet(actionSheetDetails: CGActionSheetDetails) -> UIAlertController {
        let alert = UIAlertController(
            title: actionSheetDetails.title,
            message: nil,
            preferredStyle: .ActionSheet
        )
        var actions = [ createButtonForAction(actionSheetDetails.cancelAction, .Cancel), createButtonForAction(actionSheetDetails.destructiveAction, .Destructive) ]
        actionSheetDetails.otherActions?.forEach { actions.append(createButtonForAction($0, .Default)) }
        actions.forEach { alert.addAction($0) }
        
        return alert
    }
    
    func createButtonForAction(action: CGAction, _ style: UIAlertActionStyle) -> UIAlertAction {
        return UIAlertAction(title: action.title, style: style) {  alertAction in
            action.action?()
        }
    }
}