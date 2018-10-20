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
    for (NSString *keyPath in source.transferableTemplateAttributeKeyPaths) {
        [destination setValue:[source valueForKeyPath:keyPath] forKeyPath:keyPath];
    }
}

+ (void)copyViewHierarchyFromView:(UIView *)source toView:(UIView *)destination
{
    for (__kindof UIView *sourceSubview in source.subviews) {
        UIView *subviewCopy;
        if ([sourceSubview isKindOfClass:[UICollectionView class]]) {
            UICollectionViewLayout *layoutCopy = [[sourceSubview collectionViewLayout].class new];
            subviewCopy = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layoutCopy];
        } else {
            subviewCopy = [sourceSubview.class new];
        }
        
        subviewCopy.targetView = sourceSubview.targetView;
        
        [destination addSubview:subviewCopy];
        
        [self copyViewHierarchyFromView:sourceSubview toView:subviewCopy];
    }
}

+ (instancetype)layoutTemplateWithCurrentStateForViewsInTemplate:(LDOLayoutTemplate *)layoutTemplate
{
    NSParameterAssert(layoutTemplate);
    
    LDOLayoutTemplate *currentLayoutTemplate = [LDOLayoutTemplate new];
    currentLayoutTemplate.translatesAutoresizingMaskIntoConstraints = NO;
    currentLayoutTemplate.targetView = layoutTemplate.targetView;
    
    [self copyViewHierarchyFromView:layoutTemplate toView:currentLayoutTemplate];
    
    NSMapTable<UIView *, UIView *> *currentLayoutTargetToTemplateMap = [NSMapTable strongToStrongObjectsMapTable];
    for (UIView *templateView in [currentLayoutTemplate allTemplateViews]) {
        UIView *targetView = templateView.targetView;
        
        // capture attribute state
        [self applyAttributesFrom:targetView to:templateView];

        [currentLayoutTargetToTemplateMap setObject:templateView forKey:targetView];
    }
    
    // Add constraints of `layoutTemplate` target views to `currentState` template views with the same target
    // This captures the current set of user-defined constraints
    NSSet<UIView *> *targetViews = [self.class targetViewsFor:[layoutTemplate allTemplateViews]];
    NSSet<NSLayoutConstraint *> *targetConstraints = [self.class relevantConstraintsFor:targetViews];
    NSMutableArray<NSLayoutConstraint *> *currentStateConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *targetConstraint in targetConstraints) {
        UIView *firstItem = [currentLayoutTargetToTemplateMap objectForKey:targetConstraint.firstItem];
        UIView *secondItem = [currentLayoutTargetToTemplateMap objectForKey:targetConstraint.secondItem];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                      attribute:targetConstraint.firstAttribute
                                                                      relatedBy:targetConstraint.relation
                                                                         toItem:secondItem
                                                                      attribute:targetConstraint.secondAttribute
                                                                     multiplier:targetConstraint.multiplier
                                                                       constant:targetConstraint.constant];
        constraint.priority = targetConstraint.priority;
        constraint.shouldBeArchived = targetConstraint.shouldBeArchived;
        [currentStateConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint activateConstraints:currentStateConstraints];
    
    return currentLayoutTemplate;
}

+ (NSSet<UIView *> *)targetViewsFor:(NSSet<UIView *> *)templateViews
{
    NSMutableSet<UIView *> *targetViews = [NSMutableSet new];
    
    for (UIView *templateView in templateViews) {
        UIView *targetView = templateView.targetView;
        
        if ([targetViews containsObject:targetView]) {
            NSLog(@"LDOLayoutTemplate configuration error: Target view referenced more than once: %@", targetView);
        }
        
        [targetViews addObject:targetView];
    }
    
    return [targetViews copy];
}

+ (NSSet<NSLayoutConstraint *> *)relevantConstraintsFor:(NSSet<UIView *> *)views
{
    NSMutableSet<NSLayoutConstraint *> *constraints = [NSMutableSet new];
    
    for (UIView *view in views) {
        for (NSLayoutConstraint *constraint in view.constraints) {
            // Storyboard constraints have `shouldBeArchived` set to YES - we only care about these
            // Otherwise we would mess with Apples constraints created at runtime, for example encapsulated layout constraints
            if (!constraint.shouldBeArchived) {
                continue;
            }
            BOOL betweenViews = [views containsObject:constraint.firstItem] && [views containsObject:constraint.secondItem];
            BOOL sizeConstraint = (constraint.firstAttribute == NSLayoutAttributeHeight || constraint.firstAttribute == NSLayoutAttributeWidth)
                && constraint.secondItem == nil
                && [views containsObject:constraint.firstItem];
            NSAssert(constraint.class == [NSLayoutConstraint class], @"rofl n00b");
            if (betweenViews || sizeConstraint) {
                [constraints addObject:constraint];
            }
        }
    }
    
    return [constraints copy];
}

- (NSSet<UIView *> *)allTemplateViews
{
    NSMutableSet<UIView *> *templateViews = [NSMutableSet new];
    
    [self addTemplateViewsIn:self to:templateViews];
    
    return [templateViews copy];
}

- (void)addTemplateViewsIn:(UIView *)templateView to:(NSMutableSet<UIView *> *)templateViews
{
    if (templateView.targetView) {
        [templateViews addObject:templateView];
    }
    
    for (UIView *subview in templateView.subviews) {
        [self addTemplateViewsIn:subview to:templateViews];
    }
}

- (void)apply
{
    [self applyConstraints];
    [self applyAttributes];
}

- (void)applyConstraints
{
    NSSet<UIView *> *templateViews = [self allTemplateViews];
    NSSet<UIView *> *targetViews = [self.class targetViewsFor:templateViews];
    
    // remove all constraints between target views
    NSSet<NSLayoutConstraint *> *currentConstraints = [self.class relevantConstraintsFor:targetViews];
    [NSLayoutConstraint deactivateConstraints:currentConstraints.allObjects];
    
    // re-create constraints between template views for target views
    NSSet<NSLayoutConstraint *> *templateConstraints = [self.class relevantConstraintsFor:templateViews];
    
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
        constraint.shouldBeArchived = templateConstraint.shouldBeArchived;
        [newConstraints addObject:constraint];
    }
    
    [NSLayoutConstraint activateConstraints:newConstraints];
}

- (void)applyAttributes
{
    for (UIView *templateView in [self allTemplateViews]) {
        [self.class applyAttributesFrom:templateView to:templateView.targetView];
    }
}

@end
