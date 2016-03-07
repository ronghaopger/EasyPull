# EasyPull
Let pull-to-refresh Easy for any UIScrollView

You have the flexibility to set custom view with fantastic animation.


## Usage

(see sample Xcode project in `/Demo`)

### Adding Drop Pull to Refresh

(Only support Manual Mode)

```Swift
 tableView.easy_addDropPull({
     // prepend data to dataSource, insert cells at top of table view
     // call tableView.easy_stopDropPull() when done
 })
```

### Adding Up Pull to Refresh

(Manual Mode)

```Swift
 tableView.easy_addUpPullManual({
     // prepend data to dataSource, insert cells at bottom of table view
     // call tableView.easy_stopUpPull() when done
 })
```

(Automatic Mode)

```Swift
 tableView.easy_addUpPullAutomatic({
     // prepend data to dataSource, insert cells at bottom of table view
     // call tableView.easy_stopUpPull() when done
 })
```

### Customization

The pull to refresh view can be customized using the following methods:

```Swift
 func easy_addDropPull(action: (() ->Void), customDropView: EasyViewManual? = nil)
 func easy_addUpPullManual(action: (() ->Void), customUpView: EasyViewManual? = nil)
 func easy_addUpPullAutomatic(action: (() ->Void), customUpView: EasyViewAutomatic? = nil)
```

Your custom views must implement the EasyViewManual protocol when you prefer the Manual mode or the EasyViewAutomatic protocol when you prefer the Automatic mode.
(see sample Xcode project in `/Demo/MyCusyomView.swift` or `/Demo/EasyPull/DefaultView.swift`)

## Installation

### From CocoaPods

### From Carthage

### Source files


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).