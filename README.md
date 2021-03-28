# DroidTimeSelection

[![Version](https://img.shields.io/cocoapods/v/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)
[![License](https://img.shields.io/cocoapods/l/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)
[![Platform](https://img.shields.io/cocoapods/p/DroidTimeSelection.svg?style=flat)](https://cocoapods.org/pods/DroidTimeSelection)

<p align="center">
  <img src="https://github.com/DDraiman1990/DroidTimeSelection/blob/master/Repo/Assets/droidtimeselectionlogo.png" height="70%" width="200"/>
</p>

## Coming Soon:

- [] Add Swift Package manager support.
- [ ] Add Carthage support.

## Overview

As someone who used Android for a long time, I found I really miss selecting time using the Android method. So, I brought it to iOS.

DroidTimeSelection is, well, the Android-way of selecting time.

It allows using the <b>Clock selector</b> way of picking time:
<p align="center">
  <img src="https://github.com/DDraiman1990/DroidTimeSelection/blob/master/Repo/Assets/clockexample.gif"/>
</p>
Or the <b>picker (iOS-way)</b> of picking time:
<p align="center">
  <img src="https://github.com/DDraiman1990/DroidTimeSelection/blob/master/Repo/Assets/pickerexample.gif"/>
</p>

## Installation

### Cocoapods
DroidTimeSelection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DroidTimeSelection'
```

### Swift Package Manager

#### Coming soon

### Carthage

#### Coming soon

## Usage 

### Programmatic

First of all, make sure to import "DroidTimeSelection" in all places you intend to use this.

The creation methods to all types of selectors (nested in view controller or just the view itself) can be accessed simply by calling:
```swift
DroidFactory.<SelectorType>.<DisplayType>()
```

To get the current time  value from a selector accessed via:
```swift
let currentTime = selector.time
```

To change the time format for a selector:
```swift
selector.timeFormat = .twentyFour //or twelve
```
See `TimeFormat` object for more info.

To set a selector's time value call:
```swift
selector.set(time: existingTime)
//or
selector.set(hour: 0, minutes: 0, am: false)
```
See `Time` object for more info.

All selectors will call this callback when their value changes (every time it changes, not just when its selected)
```swift
selector.onSelectionChanged = { time in
    //Do something 
}
```

To reset a selector, which sets time to 00:00 or 12am, depending on the selected `timeFormat`, simply call:
```swift
selector.reset()
```

To style a selector access it's style property:
```swift
selector.style.<property> = <value>
```
See `HybridStyle`, `ClockStyle` and `PickerStyle` for more info about what can be customized.

#### Hybrid Selector (both picker and clock)

You can give the user the ability to toggle the picker/clock mode manually by setting `showToggleButton` to `true`.
You can set the mode manually by calling:
```swift
selector.mode = .clock //or .picker
```

- <b>View Controller</b>
This is the simplest way to display all selectors without any hassle. 
It allows toggling clock and picker modes, easily customizable and already has submit and cancel buttons.
To create one:

```swift
let vc = DroidFactory.Hybrid.viewController()
vc.selector.onCancelTapped = {
    vc.dismiss(animated: true, completion: nil)
}

vc.selector.onOkTapped = {
    vc.dismiss(animated: true, completion: nil)
}

vc.selector.onSelectionChanged = { [weak self] value in
    print("TimeInterval: \(value.timeInterval)")
}
present(vc, animated: true, completion: nil)
```

This can be customized further by providing a `timeFormat` and a `style` to the creation method:
```swift
var style = HybridStyle()
style.picker.titleColor = .white
style.clock.indicatorColor = .blue
style.modeButtonTint = .red
let vc = DroidFactory
.Hybrid
.viewController(timeFormat: .twentyFour, style: style)
```

- <b>View</b>

You can display the HybridSelector as a subview of anything you'd like.
To create the view version simply call:
```swift
let view = DroidFactory.Hybrid.view()
```
The  `timeFormat` and `style` parameters are the same as `...viewController()`

#### Clock Selector

- <b>View</b>

To display the clock selector individually you need to create the Clock Selector view and
embed it as a subview.
To do that, simply:
```swift
let view = DroidFactory.Clock.view()
view.onSelectionChanged = { [weak self] value in
    //Value changed
}

view.onSelectionEnded = { [weak self] value in
    //Both hours and minutes were selected.
}
//Use AutoLayout or set frame for the view.
```

This can be customized further by providing a `timeFormat` and a `style` to the creation method:
```swift
var style = ClockStyle()
style.indicatorColor = .blue
let view = DroidFactory
.Clock
.view(timeFormat: .twentyFour, style: style)
```

See `TimeFormat` and `ClockStyle` objects for more information about styling.

- <b>View Controller</b>

If you want to use the provided ViewController simply use the HybridViewController, set the
mode to `.clock` and disable the toggle button by setting `showToggleButton` to `false` in 
the style.
```swift
var style = HybridStyle()
style.showToggleButton = false
let vc = DroidFactory
.Hybrid
.viewController(timeFormat: .twentyFour, style: style)
vc.selector.mode = .clock
//Do something with the view controller
```

#### Picker Selection

- <b>View</b>

To display the picker selector individually you need to create the Picker Selector view and
embed it as a subview.
To do that, simply:
```swift
let view = DroidFactory.Picker.view()
view.onSelectionChanged = { [weak self] value in
    //Value changed
}

//Use AutoLayout or set frame for the view.
```

This can be customized further by providing a `timeFormat` and a `style` to the creation method:
```swift
var style = PickerStyle()
style.titleColor = .blue
let view = DroidFactory
.Picker
.view(timeFormat: .twentyFour, style: style)
```

See `TimeFormat` and `PickerStyle` objects for more information about styling.

- <b>View Controller</b>

If you want to use the provided ViewController simply use the HybridViewController, set the
mode to `.picker` and disable the toggle button by setting `showToggleButton` to `false` in 
the style.
```swift
var style = HybridStyle()
style.showToggleButton = false
let vc = DroidFactory
.Hybrid
.viewController(timeFormat: .twentyFour, style: style)
vc.selector.mode = .picker
//Do something with the view controller
```

### Storyboard

All 3 selectors are IBDesignable and can be used inside a storyboard.
To use any of them, simply drag a UIView inside and change its class
to `DroidHybridSelector`, `DroidClockSelector` or `DroidPickerSelector`.
Make sure to drag it as an IBOutlet to your view controller and then bind its callbacks, style it, etc.

### Extra views

#### Time Indicator
You can use the same Time Indicator being used in the ClockSelector to display the time in any
other context. You can either create it programmatically:
```swift
let view = DroidTimeIndicatorView()
```
Or drag a UIView, in a storyboard, and give it the class of `DroidTimeIndicatorView`. 
All the relevant properties of DroidTimeIndicatorView (other than fonts) are inspectable.

#### Clock Collection View
You can use the same Clock View, for physical clock selection, being used in the ClockSelector 
for any other context. You can either create it programmatically: 
```swift
let view = DroidClockCollectionView()
```
Or drag a UIView, in a storyboard, and give it the class of `DroidClockCollectionView`. 
All the relevant properties of DroidClockCollectionView (other than fonts) are inspectable.

## Styling

You can style the following properties:

#### Clock Selector Configuration

`outerCircleTextColor`: the text color for the entries in the outer clock circle
`outerCircleBackgroundColor`: the background color for the entries in the outer clock circle
`innerCircleTextColor`: the text color for the entries in the inner clock circle
`innerCircleBackgroundColor`: the background color for the entries in the inner clock circl
`selectedColor`: the color for the current time unit being selected. Example: if hour is currently being selected then the HH of the HH:MM label will be colored with this color.
`deselectedColor`: the color for the current time unit being selected. Example: if hour is currently being selected then the MM of the HH:MM label will be colored with this color.
`indicatorColor`: the color for the line and circle indicator in the physical clock.
`selectionFont`: the font for the HH:MM time label.
`numbersFont`: the font for all the entries in the physical clock.
- Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.

#### Picker Selector Configuration

`titleColor`: the text color for the selector's title.
`titleFont`: the font for the selector's title.
`titleText`: the text in the selector's title.
`pickerFont`: the font for the picker entries.
`pickerColor`: the text color for the picker entries.
- Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.

#### Menu Selector (both methods) Configuration

`showToggleButton`: whether you want the hybrid selector to allow user to toggle between
Clock and Picker manually.
`modeButtonTint`: the color for the toggle selection button.
`pickerModeButtonContent`: the button type for the 'Picker Selection' mode.
`clockModeButtonContent`: the button type for the 'Clock Selection' mode.
`cancelButtonContent`: the button type for the cancel button.
`submitButtonContent`: the button type for the submit button.
`cancelButtonColor`: the color for the cancel button.
`submitButtonColor`: the color for the submit button.
`clock`: the styling for the inner Clock Selector. See `ClockStyle` for more info.
`picker`: the styling for the inner Picker Selector. See `PickerStyle` for more info.
- Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.


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
