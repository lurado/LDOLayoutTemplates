# LDOLayoutTemplates

[![Version](https://img.shields.io/cocoapods/v/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)
[![License](https://img.shields.io/cocoapods/l/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)
[![Platform](https://img.shields.io/cocoapods/p/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Limitations

- does not support layout guides (use a view anchored to the layout guide instead)
- all views participating in variation/variation constraints, must implement LDOVariationView

## How To

- layout your view for one orientation - let's assume landscape
- create view outside view hierarchy - this is where you design the variation: portrait
- change size of view to portrait dimensions
- set class to LDOLayoutVariationView
- create object, set class to LDOLayoutVariation
- assign outlet `destinationView` to the view controllers root view
- assign outlet `templateView` to the variation view
- copy views that should vary from view controller's view to the variation view
- modify constraints as needed
- set class to LDOLayoutVariationView

## Requirements

## Installation

LDOLayoutTemplates is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LDOLayoutTemplates"
```

## Author

sebastian@lurado.de, sebastian@lurado.de

## License

LDOLayoutTemplates is available under the MIT license. See the LICENSE file for more info.
