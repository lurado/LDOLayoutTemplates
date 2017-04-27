//
//  LDOLayoutVariation.m
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "LDOLayoutVariation.h"
#import "UIView+LDOLayoutVariation.h"

@implementation LDOLayoutVariation

+ (void)copyVariationAttributesFrom:(UIView *)source to:(UIView *)destination
{
    for (NSString *attribute in [source layoutVariationAttributes]) {
        [destination setValue:[source valueForKeyPath:attribute] forKeyPath:attribute];
    }
}

+ (void)copyViewHierarchyFromRootView:(UIView *)sourceRootView toRootView:(UIView *)destinationRootView
{
    for (UIView *sourceSubview in sourceRootView.subviews) {
        UIView *copy = [[sourceSubview class] new];
        
        copy.targetView = [sourceSubview targetView];
        
        [destinationRootView addSubview:copy];
        
        [self copyViewHierarchyFromRootView:sourceSubview toRootView:copy];
    }
}

+ (instancetype)layoutVariationForCurrentStateBasedOnVariation:(LDOLayoutVariation *)variation
{
    UIView *rootTemplateView = [[variation.templateView class] new];
    rootTemplateView.translatesAutoresizingMaskIntoConstraints = NO;
    rootTemplateView.frame = variation.destinationView.frame;
    rootTemplateView.targetView = variation.templateView.targetView;
    
    [self copyViewHierarchyFromRootView:variation.templateView toRootView:rootTemplateView];
    
    LDOLayoutVariation *currentState = [LDOLayoutVariation new];
    currentState.templateView = rootTemplateView;
    currentState.destinationView = variation.destinationView;
    
    NSMapTable<UIView *, UIView *> *currentStateTargetToTemplate = [NSMapTable weakToWeakObjectsMapTable];
    for (UIView *templateView in [currentState collectTemplateViews]) {
        UIView *targetView = templateView.targetView;
        
        // capture attribute state
        [self copyVariationAttributesFrom:targetView to:templateView];
        
#if DEBUG
        NSAssert([currentStateTargetToTemplate objectForKey:targetView] == nil, @"Target view referenced more than once: %@", targetView);
#endif
        [currentStateTargetToTemplate setObject:templateView forKey:targetView];
    }
    
    // add constraints of `variation` target views to `currentState` template views with the same target
    // this essentially caputres the current set of constraints
    NSSet<UIView *> *targetViews = [variation targetViewsFrom:[variation collectTemplateViews]];
    NSArray<NSLayoutConstraint *> *targetConstraints = [variation relevantConstraintsFor:targetViews];
    NSMutableArray<NSLayoutConstraint *> *currentStateConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *targetConstraint in targetConstraints) {
        UIView *firstItem = targetConstraint.firstItem ? [currentStateTargetToTemplate objectForKey:targetConstraint.firstItem] : nil;
        UIView *secondItem = targetConstraint.secondItem ? [currentStateTargetToTemplate objectForKey:targetConstraint.secondItem] : nil;
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                      attribute:targetConstraint.firstAttribute
                                                                      relatedBy:targetConstraint.relation
                                                                         toItem:secondItem
                                                                      attribute:targetConstraint.secondAttribute
                                                                     multiplier:targetConstraint.multiplier
                                                                       constant:targetConstraint.constant];
        [currentStateConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint activateConstraints:currentStateConstraints];
    
    return currentState;
}

- (NSSet<UIView *> *)collectTemplateViews
{
    NSMutableSet<UIView *> *templateViews = [NSMutableSet new];
    
    [self collectTemplateViewsInto:templateViews startingWith:self.templateView];
    
    return [templateViews copy];
}

- (void)collectTemplateViewsInto:(NSMutableSet<UIView *> *)set startingWith:(UIView *)templateView
{
    if (templateView.targetView) {
        [set addObject:templateView];
    }
    
    for (UIView *subview in templateView.subviews) {
        [self collectTemplateViewsInto:set startingWith:subview];
    }
}

- (NSSet<UIView *> *)targetViewsFrom:(NSSet<UIView *> *)templateViews
{
    NSMutableSet<UIView *> *targetViews = [NSMutableSet new];
    
    for (UIView *templateView in templateViews) {
        UIView *targetView = templateView.targetView;
        
#ifdef DEBUG
        NSAssert(![targetViews containsObject:targetView], @"Target view referenced more than once: %@", targetView);
#endif

        [targetViews addObject:targetView];
    }
    
    return [targetViews copy];
}

- (NSArray<NSLayoutConstraint *> *)relevantConstraintsFor:(NSSet<UIView *> *)views
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray new];
    
    for (UIView *view in views) {
        for (NSLayoutConstraint *constraint in view.constraints) {
            BOOL betweenViews = [views containsObject:constraint.firstItem] && [views containsObject:constraint.secondItem];
            BOOL sizeConstraint = [constraint isMemberOfClass:[NSLayoutConstraint class]] && (constraint.firstAttribute == NSLayoutAttributeHeight || constraint.firstAttribute == NSLayoutAttributeWidth);
            sizeConstraint = sizeConstraint && ![constraint.identifier containsString:@"-Encapsulated-Layout-"];
            if (betweenViews || sizeConstraint) {
                [constraints addObject:constraint];
            }
        }
    }
    
    return [constraints copy];
}

- (void)apply
{
    NSSet<UIView *> *templateViews = [self collectTemplateViews];
    
    [self applyConstraints:templateViews];
    
    for (UIView *templateView in templateViews) {
        [self.class copyVariationAttributesFrom:templateView to:templateView.targetView];
    }
}

- (void)applyConstraints:(NSSet<UIView *> *)templateViews
{
    NSSet<UIView *> *targetViews = [self targetViewsFrom:templateViews];
    
    // collect all constraints between target views (to be deactivated)
    NSArray<NSLayoutConstraint *> *currentConstraints = [self relevantConstraintsFor:targetViews];
    
    // re-create constraints between template views for target views
    NSArray<NSLayoutConstraint *> *templateConstraints = [self relevantConstraintsFor:templateViews];
    
    NSMutableArray<NSLayoutConstraint *> *newConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *templateConstraint in templateConstraints) {
        UIView *firstItem = [templateConstraint.firstItem targetView];
        UIView *secondItem = [templateConstraint.secondItem targetView];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                      attribute:templateConstraint.firstAttribute
                                                                      relatedBy:templateConstraint.relation
                                                                         toItem:secondItem
                                                                      attribute:templateConstraint.secondAttribute
                                                                     multiplier:templateConstraint.multiplier
                                                                       constant:templateConstraint.constant];
        [newConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint deactivateConstraints:currentConstraints];
    [NSLayoutConstraint activateConstraints:newConstraints];
}

@end
