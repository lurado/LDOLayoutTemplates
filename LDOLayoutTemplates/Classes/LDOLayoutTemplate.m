//
//  LDOLayoutTemplate.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "LDOLayoutTemplate.h"
#import "UIView+LDOLayoutTemplates.h"

@implementation LDOLayoutTemplate

+ (void)applyAttributesFrom:(UIView *)source to:(UIView *)destination
{
    for (NSString *keyPath in [source transferableTemplateAttributeKeyPaths]) {
        [destination setValue:[source valueForKeyPath:keyPath] forKeyPath:keyPath];
    }
}

+ (void)copyViewHierarchyFromRootView:(UIView *)sourceRootView toRootView:(UIView *)destinationRootView
{
    for (__kindof UIView *sourceSubview in sourceRootView.subviews) {
        UIView *copy;
        if ([sourceSubview isKindOfClass:[UICollectionView class]]) {
            copy = [[UICollectionView alloc] initWithFrame:CGRectZero
                                      collectionViewLayout:[sourceSubview collectionViewLayout]];
        } else {
            copy = [[sourceSubview class] new];
        }
        
        copy.targetView = [sourceSubview targetView];
        
        [destinationRootView addSubview:copy];
        
        [self copyViewHierarchyFromRootView:sourceSubview toRootView:copy];
    }
}

+ (instancetype)layoutTemplateForCurrentStateBasedOnTemplate:(LDOLayoutTemplate *)layoutTemplate
{
    UIView *rootTemplateView = [[layoutTemplate.templateView class] new];
    rootTemplateView.translatesAutoresizingMaskIntoConstraints = NO;
    rootTemplateView.frame = layoutTemplate.destinationView.frame;
    rootTemplateView.targetView = layoutTemplate.templateView.targetView;
    
    [self copyViewHierarchyFromRootView:layoutTemplate.templateView toRootView:rootTemplateView];
    
    LDOLayoutTemplate *currentState = [LDOLayoutTemplate new];
    currentState.templateView = rootTemplateView;
    currentState.destinationView = layoutTemplate.destinationView;
    
    NSMapTable<UIView *, UIView *> *currentStateTargetToTemplate = [NSMapTable weakToWeakObjectsMapTable];
    for (UIView *templateView in [currentState collectTemplateViews]) {
        UIView *targetView = templateView.targetView;
        
        // capture attribute state
        [self applyAttributesFrom:targetView to:templateView];
        
#if DEBUG
        NSAssert([currentStateTargetToTemplate objectForKey:targetView] == nil, @"Target view referenced more than once: %@", targetView);
#endif
        [currentStateTargetToTemplate setObject:templateView forKey:targetView];
    }
    
    // add constraints of `layoutTemplate` target views to `currentState` template views with the same target
    // this essentially captures the current set of constraints
    NSSet<UIView *> *targetViews = [layoutTemplate targetViewsFrom:[layoutTemplate collectTemplateViews]];
    NSArray<NSLayoutConstraint *> *targetConstraints = [layoutTemplate relevantConstraintsFor:targetViews];
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
        constraint.priority = targetConstraint.priority;
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
            BOOL sizeConstraint = constraint.secondItem == nil
                    && (constraint.firstAttribute == NSLayoutAttributeHeight || constraint.firstAttribute == NSLayoutAttributeWidth)
                    && [constraint isMemberOfClass:[NSLayoutConstraint class]]
                    && ![constraint.identifier containsString:@"-Encapsulated-Layout-"];
            if (betweenViews || sizeConstraint) {
                [constraints addObject:constraint];
            }
        }
    }
    
    return [constraints copy];
}

- (void)apply
{
    [self applyConstraints];
    [self applyAttributes];
}

- (void)applyConstraints
{
    NSSet<UIView *> *templateViews = [self collectTemplateViews];
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
        constraint.priority = templateConstraint.priority;
        [newConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint deactivateConstraints:currentConstraints];
    [NSLayoutConstraint activateConstraints:newConstraints];
}

- (void)applyAttributes
{
    NSSet<UIView *> *templateViews = [self collectTemplateViews];
    
    for (UIView *templateView in templateViews) {
        [self.class applyAttributesFrom:templateView to:templateView.targetView];
    }
}

@end
