# EasyPull
Let pull-to-refresh Easy for any UIScrollView

## Usage

(see sample Xcode project in `/Demo`)

### Adding Drop Pull to Refresh

```Swift
 tableView.easy_addDropPull({
     // prepend data to dataSource, insert cells at top of table view
     // call tableView.easy_stopDropPull() when done
 })
```

### Adding Up Pull to Refresh

#### Manual Mode

```Swift
 tableView.easy_addUpPullManual({
     // prepend data to dataSource, insert cells at bottom of table view
     // call tableView.easy_stopUpPull() when done
 })
```

#### Automatic Mode

```Swift
 tableView.easy_addUpPullAutomatic({
     // prepend data to dataSource, insert cells at bottom of table view
     // call tableView.easy_stopUpPull() when done
 })
```

## Installation

### From CocoaPods

### From Carthage

### Source files


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).