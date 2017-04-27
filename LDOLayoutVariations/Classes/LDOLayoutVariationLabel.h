//
//  LDOLayoutVariationLabel.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 17.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import UIKit;
#import "LDOVariationView.h"

@interface LDOLayoutVariationLabel : UILabel <LDOVariationView>

@property (nonatomic, weak) IBOutlet UILabel *targetView;

@end