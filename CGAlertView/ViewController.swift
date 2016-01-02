//
//  ViewController.swift
//  CGAlertView
//
//  Created by Chris Griffiths on 02/01/2016.
//  Copyright © 2016 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func simpleiOS7AlertButtonPressed(sender: AnyObject) {
        let alertView = CGAlertView(alertViewManager: CGAlertViewManager())
        alertView.showAlert("Title", message: "Message", cancelAction: CGAction(title: "Cancel") {
            print("cancel called")
            }, parentViewController: self)
    }

    @IBAction func simpleAlertButtonPressed(sender: AnyObject) {
        let cancelAction = CGAction(title: "Cancel") {
            print("cancel called")
        }
        CGAlertView().showAlert("Title", message: "Message", cancelAction: cancelAction, parentViewController: self)
    }

    @IBAction func complexAlertButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: "Title",
            message: "Message",
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            otherActions: [
                CGAction(title: "Action") {
                    print("Action called")
                },
                CGAction(title: "Action1") {
                    print("Action1 called")
                }
            ]
        )
        CGAlertView().showAlert(alertDetails, parentViewController: self)
    }
}
