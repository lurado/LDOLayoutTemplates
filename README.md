# LDOLayoutTemplates

Visually design multiple layouts of a view in IB and easily transition between them

[![Version](https://img.shields.io/cocoapods/v/LDOLayoutTemplates.svg?style=flat)](https://cocoapods.org/pods/LDOLayoutTemplates)
[![License](https://img.shields.io/cocoapods/l/LDOLayoutTemplates.svg?style=flat)](https://cocoapods.org/pods/LDOLayoutTemplates)
[![Platform](https://img.shields.io/cocoapods/p/LDOLayoutTemplates.svg?style=flat)](https://cocoapods.org/pods/LDOLayoutTemplates)

### Get this...

![Demo](Screenshots/DashboardExample.gif)

### ...with this

```Swift
class ComplexViewController: UIViewController {
    @IBOutlet weak var portraitLargeListLayout: LDOLayoutTemplate!
    @IBOutlet weak var landscapeLargeListLayout: LDOLayoutTemplate!
    private var defaultLayout: LDOLayoutTemplate!
    private var largeListLayoutActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLayout = LDOLayoutTemplate(withCurrentStateForViewsIn: portraitLargeListLayout)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.applyLayout(for: size)
        })
    }
    
    @IBAction func toggleLargeListLayout() {
        largeListLayoutActive.toggle()
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.applyLayout(for: self.view.bounds.size)
        }
    }
    
    private func applyLayout(for size: CGSize) {
        if largeListLayoutActive {
            if size.width > size.height {
                landscapeLargeListLayout.apply()
            } else {
                portraitLargeListLayout.apply()
            }
        } else {
            defaultLayout.apply()
        }
        view.layoutIfNeeded()
    }
}
```

## Motivation

Visual lay outing in IB is great, we truly love it!
However if a screen layout differs between orientations or if a view has two modes (large and a collapsed mode for example), setting up constraints to support both quickly becomes a mess.
Maintaining the outlets to activate and deactivate the constraints isn't fun either.
Things only get worse if you have more than two variations.
Wouldn't it be nice to design the different layouts separately and have an easy way to switch from one to another? 
We thought so, too.

## Example

To run the example project, clone the repo, open workspace in the `Example` folder and hit run.
Alternatively, you can use `pod try https://github.com/lurado/LDOLayoutTemplates`. 
The complex example only works on iPad.

## How To

1. Lay out your view for one orientation - let's assume landscape.
1. Create a view outside the view hierarchy. This is your layout template where you design the 
    variation (portrait).
1. Change the size of that view to portrait dimensions (not really necessary, but it makes 
    designing it easier).
1. Copy or re-create the views that should vary from the view controller's view to the template view. If you copy your views, make sure to disconnect any outlets.
1. Modify the constraints as needed.
1. Connect the `targetView` of the template views to their corresponding views in the view controller's 
    view. It's important to connect all views participating in constraints of a template. 
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

Not only the constraint setup can vary for a template, view attributes can be different, too. To support
this either add a list of comma separated attributes to Transferred Template Attribute Key Paths in the 
Attribute Inspector in Interface Builder or override `-transferableTemplateAttributeKeyPaths` in your `UIView` subclass.

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
- Besides the "between views" constraints, width and height constraints are collected as well and handled accordingly.

## Author

Raschke & Ludwig GbR, https://www.lurado.com/

## License

LDOLayoutTemplates is available under the MIT license. See the LICENSE file for more information.
