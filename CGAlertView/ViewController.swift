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
        let alertView = CGAlertController(alertControllerManager: CGLegacyAlertManager())
        alertView.showAlert("Title", message: "Message", cancelAction: CGAction(title: "Cancel") {
            print("cancel called")
            }, parentViewController: self)
    }

    @IBAction func simpleAlertButtonPressed(sender: AnyObject) {
        let cancelAction = CGAction(title: "Cancel") {
            print("cancel called")
        }
        CGAlertController().showAlert("Title", message: "Message", cancelAction: cancelAction, parentViewController: self)
    }

    @IBAction func complexAlertButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: "Title",
            message: "Message",
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            destructiveAction: nil,
            otherActions: [
                CGAction(title: "Action") {
                    print("Action called")
                },
                CGAction(title: "Action1") {
                    print("Action1 called")
                }
            ]
        )
        CGAlertController().showAlert(alertDetails, parentViewController: self)
    }
    
    
    // Mark - Action Sheet
    
    
    @IBAction func simpleiOS7ActionSheetButtonPressed(sender: AnyObject) {
        let actionSheet = CGAlertController(alertControllerManager: CGLegacyAlertManager())
        actionSheet.showActionSheet("Title", cancelAction: CGAction(title: "Cancel") {
            print("cancel called")
            }, destructiveAction: CGAction(title: "Destructive") {
                print("destructive called")
            }, parentViewController: self)
    }
    
    @IBAction func simpleActionSheetButtonPressed(sender: AnyObject) {
        let cancelAction = CGAction(title: "Cancel") {
            print("cancel called")
        }
        let destructiveAction = CGAction(title: "Destructive") {
            print("destructive called")
        }
        CGAlertController().showActionSheet("Title", cancelAction: cancelAction, destructiveAction: destructiveAction, parentViewController: self)
    }
    
    @IBAction func complexActionSheetButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: "Title",
            message: "Message",
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            destructiveAction: CGAction(title: "Destructive") {
                print("destructive called")
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
        CGAlertController().showActionSheet(alertDetails, parentViewController: self)
    }
    
    @IBAction func complexActionSheetNoTitleButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: nil,
            message: nil,
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            destructiveAction: CGAction(title: "Destructive") {
                print("destructive called")
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
        CGAlertController().showActionSheet(alertDetails, parentViewController: self)
    }
    
    @IBAction func complexColoredActionSheetNoTitleButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: "Sort By",
            message: nil,
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            destructiveAction: nil,
            otherActions: [
                CGAction(title: "Action") {
                    print("Action called")
                },
                CGAction(title: "Action1") {
                    print("Action1 called")
                }
            ]
        )
        CGAlertController().showActionSheet(alertDetails, parentViewController: self, buttonTextColor: UIColor.brownColor())
    }
    
    @IBAction func complexColorediOS7ActionSheetNoTitleButtonPressed(sender: AnyObject) {
        let alertDetails = CGAlertDetails(
            title: "Sort By",
            message: nil,
            cancelAction: CGAction(title: "Cancel") {
                print("cancel called")
            },
            destructiveAction: nil,
            otherActions: [
                CGAction(title: "Action") {
                    print("Action called")
                },
                CGAction(title: "Action1") {
                    print("Action1 called")
                }
            ]
        )
         let actionSheet = CGAlertController(alertControllerManager: CGLegacyAlertManager())
        actionSheet.showActionSheet(alertDetails, parentViewController: self, buttonTextColor: UIColor.grayColor())
    }


}
