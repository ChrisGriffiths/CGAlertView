#CGAlertView

CGAlertView provides a simple API for both iOS 7 upwarps, wrapping UIAlertView and UIAlertController

##Why

UIAlertView was depricated in iOS8 in favour of UIAlertController, but iOS7 doesn't support this. CGAlertView was created to allow people to utilise Apple's alert frameworks regardless of iOS version or platform

##Use

###Simple

Displayed a simple AlertView with Title, Message and Cancel Action

```
let cancelAction = CGAction(title: "Cancel") {
    print("cancel called")
}
CGAlertView().showAlert("Title", message: "Message", cancelAction: cancelAction, parentViewController: self)
```
###Full

Displayed more complex AlertView with multiple buttons

```
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
```
## Requirements
- iOS 7.0+
- Xcode 7

This project currenly do not support package managers such as `CocoaPods` or `Carthage` as they only support iOS8 onwards

####CocoaSeeds

Recommened alternavtive to Git Submodules
https://github.com/devxoul/CocoaSeeds

####Manually (iOS 7+, OS X 10.9+)

To use this library in your project manually you may:  

1. From the Source folder, just drag [CGAlerView.swift](https://github.com/ChrisGriffiths/CGAlertView/Source/blob/master/CGAlertView.swift) to the project tree
