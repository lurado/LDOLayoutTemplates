//
//  LDOLayoutVariationImageView.h
//  Pods
//
//  Created by Sebastian Ludwig on 17.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import UIKit;
#import "LDOVariationView.h"

@interface LDOLayoutVariationImageView : UIImageView <LDOVariationView>

@property (nonatomic, weak) IBOutlet UIImageView *targetView;

@end
