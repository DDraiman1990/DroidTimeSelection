# DroidTimeSelection

[![Version](https://img.shields.io/cocoapods/v/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)
[![License](https://img.shields.io/cocoapods/l/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)
[![Platform](https://img.shields.io/cocoapods/p/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)

<p align="center">
  <img src="https://raw.githubusercontent.com/DDraiman1990/DroidTimeSelection/master/Repo/Assets/droidtimeselectionlogo.png" height="70%" width="200"/>
</p>

## Coming Soon:

- [ ] Full Storyboard support.
- [ ] Add Swift Package manager support.
- [ ] Add Carthage support.
- [ ] Add smoother animations for mode transitions.
- [ ] Add the color-invert effect similar to the original android selector.

## Overview

As someone who used Android for a long time, I found I really miss selecting time using the Android method. So, I brought it to iOS.

DroidTimeSelection is, well, the Android-way of selecting time.

It allows using the <b>Clock selector</b> way of picking time:
<p align="center">
  <img src="https://raw.githubusercontent.com/DDraiman1990/DroidTimeSelection/master/Repo/Assets/clockexample.gif"/>
</p>
Or the <b>picker (iOS-way)</b> of picking time:
<p align="center">
  <img src="https://raw.githubusercontent.com/DDraiman1990/DroidTimeSelection/master/Repo/Assets/pickerexample.gif"/>
</p>

## Installation

DroidTimeSelection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DroidTimeSelection'
```

## Usage 

### Programmatic

First of all, make sure to import "DroidTimeSelection" in all places you intend to use this.

#### Menu with both (both methods)

Create an instance of the menu:
```swift
let menuMethod = DroidTimeSelection()
```

You can also modify the configuration for the menu
```swift
menuMethod.config.timeFormat = .twelve
menuMethod.config.okButtonColor = .blue
//etc
```

You can set an already existing time (either Time format or hours, minutes, am/pm):
```swift
menuMethod.set(time: existingTime)
//or
menuMethod.set(hour: 0, minutes: 0, am: false)
```

To listen for menu events, access the following closures:
```swift
menuMethod.onOkTapped = { [weak self] in
    let value = menuMethod.value //the time selected
    //Your code here.
}

menuMethod.onCancelTapped = { [weak self] in
    //Your code here.
}

menuMethod.onSelectionChanged = { [weak self] value in
    //Your code here
}
```

#### Clock Selection

Create an instance of the menu:
```swift
let clockMethod = DroidClockSelector(frame: .zero)
```

Add it somewhere via absolute position or auto layout.

You can also modify the configuration for the menu
```swift
clockMethod.config.timeFormat = .twelve
clockMethod.config.timeColor = .blue
//etc
```

You can set an already existing time (either Time format or hours, minutes, am/pm):
```swift
clockMethod.set(time: existingTime)
//or
clockMethod.set(hour: 0, minutes: 0, am: false)
```

To listen for menu events, access the following closures:
```swift
clockMethod.onSelectionChanged = { [weak self] value in
    //Your code here
}
```

#### Picker Selection

Create an instance of the menu:
```swift
let pickerMethod = DroidPickerSelector(frame: .zero)
```

Add it somewhere via absolute position or auto layout.

You can also modify the configuration for the menu
```swift
pickerMethod.config.timeFormat = .twelve
pickerMethod.config.timeColor = .blue
//etc
```

You can set an already existing time (either Time format or hours, minutes, am/pm):
```swift
pickerMethod.set(time: existingTime)
//or
pickerMethod.set(hour: 0, minutes: 0, am: false)
```

To listen for menu events, access the following closures:
```swift
pickerMethod.onSelectionChanged = { [weak self] value in
    //Your code here
}
```

### Storyboard

#### Coming Soon.

## Customization

You can customize the following aspects:

#### Clock Selector Configuration

```swift
largeSelectionFont: UIFont (default: .systemFont(ofSize: 18))
smallSelectionFont: UIFont (default: .systemFont(ofSize: 14))
largeSelectionColor: UIColor (default: .white)
smallSelectionColor: UIColor (default: .gray)
timeFont: UIFont (default: .systemFont(ofSize: 60))
amPmFont: UIFont (default: .systemFont(ofSize: 30))
timeColor: UIColor (default: .gray)
highlightedTimeColor: UIColor (default: .white)
selectionIndicatorColor: UIColor (default: .systemTeal)
selectionBackgroundColor: UIColor (default: .clear)
timeFormat: DroidTimeFormat (default: .twentyFour. Either .twentyFour or .twelve)
```

#### Picker Selector Configuration

```swift
cancelButtonColor: UIColor (default: .white)
okButtonColor: UIColor (default: .white)
modeButtonColor: UIColor (default: .white)
okButtonText: String (default: "OK")
cancelButtonText: String (default: "CANCEL")
timeFormat: DroidTimeFormat (default: .twentyFour. Either .twentyFour or .twelve)
```

#### Menu Selector (both methods) Configuration

```swift
titleFont: UIFont (default: .systemFont(ofSize: 26, weight: .bold))
titleColor: UIColor (default: .white)
pickerColor: UIColor (default: .white)
titleText: String (default: "Set Time")
timeFormat: DroidTimeFormat (default: .twentyFour)
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

 - iOS 11 or above.

## Author

DDraiman1990, ddraiman1990@gmail.com a.k.a Nexxmark Studio.

## License

DroidTimeSelection is available under the MIT license. See the LICENSE file for more info.

## Attributions

### Library's logo
The original icon was mixed from an icon made by [Those Icons](https://www.flaticon.com/free-icon/star-wars_813488?term=droid&page=1&position=10) and [Freepik](https://www.flaticon.com/authors/freepik) both from [www.flaticon.com](https://www.flaticon.com/).
