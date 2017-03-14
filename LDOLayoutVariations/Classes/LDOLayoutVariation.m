//
//  LDOLayoutVariation.m
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

#import "LDOLayoutVariation.h"
#import "LDOVariationView.h"
#import "LDOTargetingView.h"
#import "LDOLVTopLayoutGuide.h"
#import "LDOLVBottomLayoutGuide.h"

@implementation LDOLayoutVariation

+ (void)copyViewHierarchyFromRootView:(UIView<LDOTargetingView> *)sourceRootView toRootView:(UIView<LDOTargetingView> *)destinationRootView
{
    for (__kindof UIView *sourceSubview in sourceRootView.subviews) {
        if ([sourceSubview conformsToProtocol:@protocol(LDOTargetingView)]) {
            UIView<LDOTargetingView> *copy = [[sourceSubview class] new];
            
            copy.targetView = [sourceSubview targetView];
            
            [destinationRootView addSubview:copy];
        }
    }
}

+ (instancetype)layoutVariationForCurrentStateBasedOnVariation:(LDOLayoutVariation *)variation
{
    UIView<LDOTargetingView> *templateView = [[variation.templateView class] new];
    templateView.translatesAutoresizingMaskIntoConstraints = NO;
    templateView.frame = variation.destinationView.frame;
    templateView.targetView = variation.templateView.targetView;
    
    [self copyViewHierarchyFromRootView:variation.templateView toRootView:templateView];
    
    LDOLayoutVariation *currentState = [LDOLayoutVariation new];
    currentState.templateView = templateView;
    currentState.destinationView = variation.destinationView;
    
    NSMapTable<UIView *, UIView<LDOTargetingView> *> *currentStateTargetToVariation = [NSMapTable weakToWeakObjectsMapTable];
    for (UIView<LDOTargetingView> *variation in [currentState collectVariationViews]) {
        UIView *target = variation.targetView;
#if DEBUG
        NSAssert([currentStateTargetToVariation objectForKey:target] == nil, @"Target view referenced more than once: %@", target);
#endif
        [currentStateTargetToVariation setObject:variation forKey:target];
    }
    
    // add constraints of variation target views to variation views with the same target
    NSSet<UIView *> *targetViews = [variation targetViewsFrom:[variation collectVariationViews]];
    NSArray<NSLayoutConstraint *> *targetConstraints = [variation relevantConstraintsFor:targetViews];
    NSMutableArray<NSLayoutConstraint *> *variationConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *targetConstraint in targetConstraints) {
        UIView *firstItem = targetConstraint.firstItem ? [currentStateTargetToVariation objectForKey:targetConstraint.firstItem] : nil;
        UIView *secondItem = targetConstraint.secondItem ? [currentStateTargetToVariation objectForKey:targetConstraint.secondItem] : nil;
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                      attribute:targetConstraint.firstAttribute
                                                                      relatedBy:targetConstraint.relation
                                                                         toItem:secondItem
                                                                      attribute:targetConstraint.secondAttribute
                                                                     multiplier:targetConstraint.multiplier
                                                                       constant:targetConstraint.constant];
        [variationConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint activateConstraints:variationConstraints];
    
    return currentState;
}

- (void)collectVariationViewsInto:(NSMutableSet<UIView<LDOVariationView> *> *)set startingWith:(UIView<LDOVariationView> *)view
{
    if ([[view class] conformsToProtocol:@protocol(LDOVariationView)]) {
        [set addObject:view];
    }
    
    for (UIView *subview in view.subviews) {
        [self collectVariationViewsInto:set startingWith:subview];
    }
}

- (NSSet<UIView<LDOVariationView> *> *)collectVariationViews
{
    NSMutableSet<UIView<LDOVariationView> *> *variationViews = [NSMutableSet new];
    
    [self collectVariationViewsInto:variationViews startingWith:self.templateView];
    
    return [variationViews copy];
}

- (NSSet<UIView *> *)targetViewsFrom:(NSSet<UIView<LDOVariationView> *> *)variationViews
{
    NSMutableSet<UIView *> *targetViews = [NSMutableSet new];
    
    for (UIView *view in variationViews) {
        if (![view conformsToProtocol:@protocol(LDOTargetingView)]) {
            continue;
        }
        
        UIView<LDOTargetingView> *variationView = view;
        
        UIView *targetView = variationView.targetView;
        
#ifdef DEBUG
        NSParameterAssert(targetView);
        NSAssert(![targetViews containsObject:targetView], @"Target view referenced more than once: %@", targetView);
#endif

        [targetViews addObject:targetView];
    }
    
    return [targetViews copy];
}

- (NSArray<NSLayoutConstraint *> *)relevantConstraintsFor:(NSSet<UIView *> *)views
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray new];
    
    Protocol *layoutGuide = @protocol(UILayoutSupport);
    for (UIView *view in views) {
        for (NSLayoutConstraint *constraint in view.constraints) {
            BOOL unwantedHelperLayoutGuideConstraint = [constraint.firstItem isKindOfClass:[LDOLVTopLayoutGuide class]] && constraint.firstAttribute != NSLayoutAttributeBottom
                || [constraint.secondItem isKindOfClass:[LDOLVTopLayoutGuide class]] && constraint.secondAttribute != NSLayoutAttributeBottom
                || [constraint.firstItem isKindOfClass:[LDOLVBottomLayoutGuide class]] && constraint.firstAttribute != NSLayoutAttributeTop
                || [constraint.secondItem isKindOfClass:[LDOLVBottomLayoutGuide class]] && constraint.secondAttribute != NSLayoutAttributeTop;
            if (unwantedHelperLayoutGuideConstraint) {
                continue;
            }
            
            BOOL firstViewContained = [views containsObject:constraint.firstItem];
            BOOL secondViewContained = [views containsObject:constraint.secondItem];
            BOOL betweenViews = firstViewContained && secondViewContained;
            // TODO: this also needs to check which edge of the layout guide is used (at least...) 
            BOOL toLayoutGuide = firstViewContained && [constraint.secondItem conformsToProtocol:layoutGuide] || secondViewContained && [constraint.firstItem conformsToProtocol:layoutGuide];
            BOOL sizeConstraint = [constraint isMemberOfClass:[NSLayoutConstraint class]] && (constraint.firstAttribute == NSLayoutAttributeHeight || constraint.firstAttribute == NSLayoutAttributeWidth);
            sizeConstraint = sizeConstraint && ![constraint.identifier containsString:@"-Encapsulated-Layout-"];
            if (betweenViews || toLayoutGuide || sizeConstraint) {
                [constraints addObject:constraint];
            }
        }
    }
    
    return [constraints copy];
}

// TODO:
// - Layout guides
// - attributes (hidden, alpha, ..)

- (NSLayoutConstraint *)constraintAnchor:(NSLayoutAnchor *)firstAnchor to:(NSLayoutAnchor *)secondAnchor basedOnConstraint:(NSLayoutConstraint *)baseConstraint
{
    NSLayoutConstraint *constraint;
    switch (baseConstraint.relation) {
        case NSLayoutRelationEqual:
            constraint = [firstAnchor constraintEqualToAnchor:secondAnchor constant:baseConstraint.constant];
            break;
        case NSLayoutRelationLessThanOrEqual:
            constraint = [firstAnchor constraintLessThanOrEqualToAnchor:secondAnchor constant:baseConstraint.constant];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            constraint = [firstAnchor constraintGreaterThanOrEqualToAnchor:secondAnchor constant:baseConstraint.constant];
            break;
    }
    
    constraint.priority = baseConstraint.priority;
    
    return constraint;
}

- (void)applyInViewController:(UIViewController *)viewController
{
    NSSet<UIView<LDOVariationView> *> *variationViews = [self collectVariationViews];
    
    NSSet<UIView *> *targetViews = [self targetViewsFrom:variationViews];
    
    // collect all constraints between target views (to be deactivated)
    NSArray<NSLayoutConstraint *> *currentConstraints = [self relevantConstraintsFor:targetViews];
    
    // re-create constraints between LDOTargetingViews for target views
    NSArray<NSLayoutConstraint *> *templateConstraints = [self relevantConstraintsFor:variationViews];
    
    NSMutableArray<NSLayoutConstraint *> *newConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *templateConstraint in templateConstraints) {
        NSLayoutConstraint *constraint;
        if ([templateConstraint.firstItem isKindOfClass:[LDOLVTopLayoutGuide class]]) {
            UIView *view = [templateConstraint.secondItem targetView];
            constraint = [self constraintAnchor:view.topAnchor to:viewController.topLayoutGuide.bottomAnchor basedOnConstraint:templateConstraint];
        } else if ([templateConstraint.firstItem isKindOfClass:[LDOLVBottomLayoutGuide class]]) {
            UIView *view = [templateConstraint.secondItem targetView];
            constraint = [self constraintAnchor:view.bottomAnchor to:viewController.bottomLayoutGuide.topAnchor basedOnConstraint:templateConstraint];
        } else if ([templateConstraint.secondItem isKindOfClass:[LDOLVTopLayoutGuide class]]) {
            UIView *view = [templateConstraint.firstItem targetView];
            constraint = [self constraintAnchor:view.topAnchor to:viewController.topLayoutGuide.bottomAnchor basedOnConstraint:templateConstraint];
        } else if ([templateConstraint.secondItem isKindOfClass:[LDOLVBottomLayoutGuide class]]) {
            UIView *view = [templateConstraint.firstItem targetView];
            constraint = [self constraintAnchor:view.bottomAnchor to:viewController.bottomLayoutGuide.topAnchor basedOnConstraint:templateConstraint];
        } else {
            UIView *firstItem = [templateConstraint.firstItem targetView];
            UIView *secondItem = [templateConstraint.secondItem targetView];
            
            constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                      attribute:templateConstraint.firstAttribute
                                                      relatedBy:templateConstraint.relation
                                                         toItem:secondItem
                                                      attribute:templateConstraint.secondAttribute
                                                     multiplier:templateConstraint.multiplier
                                                       constant:templateConstraint.constant];
        }
        
        [newConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint deactivateConstraints:currentConstraints];
    [NSLayoutConstraint activateConstraints:newConstraints];
}

@end
