//
//  LDOLVButton.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

@import UIKit;
#import "LDOTargetingView.h"

@interface LDOLVButton : UIButton <LDOTargetingView>

@property (nonatomic, weak) IBOutlet UIButton *targetView;

@end
