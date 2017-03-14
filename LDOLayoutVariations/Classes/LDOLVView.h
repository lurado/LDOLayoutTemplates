//
//  LDOLVView.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

@import UIKit;
#import "LDOTargetingView.h"

@interface LDOLVView : UIView <LDOTargetingView>

@property (nonatomic, weak) IBOutlet UIView *targetView;

@end
