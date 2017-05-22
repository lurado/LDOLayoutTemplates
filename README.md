# LDOLayoutTemplates

Design different states of a screen in IB and easily transition between them

[![Version](https://img.shields.io/cocoapods/v/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)
[![License](https://img.shields.io/cocoapods/l/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)
[![Platform](https://img.shields.io/cocoapods/p/LDOLayoutTemplates.svg?style=flat)](http://cocoapods.org/pods/LDOLayoutTemplates)

## Motivation

If a screen layout differs between orientations, setting up constraints to support both quickly becomes
a mess. Maintaining the outlets to activate and deactivate the constraints isn't fun either. Wouldn't it
be nice to maintain the diffent layouts separately and have an easy way to switch from one to another? 
We thought so, too.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
Alternatively, you can use `pod try https://github.com/lurado/LDOLayoutTemplates`.

## How To

1. Lay out your view for one orientation - let's assume landscape.
1. Create a view outside the view hierarchy. This is your layout template where you design the 
    variation (portrait).
1. Change the size of that view to portrait dimensions (not really necessary, but it makes 
    designing it easier).
1. Copy or re-create the views that should vary from the view controller's view to the template view.
1. Modify the constraints as needed.
1. Connect the `targetView` of the template views to their corresponding views in the view controller's 
    view. It's imporant to connect all views paricipating in constraints of a template. 
    (Also just ignore the `targetView` outlet on the view controller views.)
1. Create an object and set its class to `LDOLayoutTemplate`.
1. Connect the `destinationView` outlet to the view controllers root view.
1. Connect the `templateView` outlet to the template view from step 2.
1. Add and connect an outlet for the `LDOLayoutTemplate` object to your view controller.
1. Call `apply` on that object to switch to your template (for example on orientation change). 
    You can wrap the in an `UIView` animation block, if you want a smooth transition.
1. To be able to switch back, create another instance of `LDOLayoutTemplate` (for example in `viewDidLoad`) 
    for the initial state with `LDOLayoutTemplate+layoutTemplateForCurrentStateBasedOnTemplate:`. Calling `apply` 
    on this one, will restore the state.
1. Setup as many templates as you need and happily switch between them.

## Attribute changes

Not only the constraint setup can vary for a template, view attributes are supported, too. Most notably that's
`alpha` and `hidden`. Set a template view's `alpha` value to `0` and it will disappear when applying the template.

Currently supported are:

- `UIView`
    - `alpha`
    - `hidden`
- `UIScrollView`
    - `scrollEnabled`
- `UICollectionView`
    - `scrollDirection` of the flow layout (if a flow layout is used)

This list isn't very extensive. It's only what we've initially needed and it will grow over time. Feel free to open an 
issue or send a PR.

You can easily support your own `IBInspectable` properties by implementing `-transferableTemplateAttributeKeyPaths` 
in your view subclass. That's all - the rest will be taken care of.

## Limitations

- Layout guides are not supported. Use a helper view anchored to the layout guide instead.
- All views participating in template view constraints **must** have their `targetView` outlet set.

## Installation

LDOLayoutTemplates is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LDOLayoutTemplates"
```

## How does it work?

The algorithm is actually pretty simple and basically works as follows:

- Iterate over all views of a template and collect all constraints between views with a target view. These 
    are the constraints that will be _activated_ when `apply` is called.
- Iterate over all the target views (the ones in your view controller's view having a `targetView` outlet 
    pointing at them) and collect all constraints between them. These constraints will be _deactivated_ when 
    `apply` is called.
- Besides the "between views" constraints, width and height constraints are collected as well.

## Author

Raschke & Ludwig GbR, http://www.lurado.com

## License

LDOLayoutTemplates is available under the MIT license. See the LICENSE file for more info.
