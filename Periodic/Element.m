//
//  Element.m
//  Periodic
//
//  Created by James Kolsby on 11/17/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "Element.h"
#import "AppDataObject.h"
#import <QuartzCore/QuartzCore.h>

@implementation Element

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action: @selector(elementSelect) forControlEvents: UIControlEventTouchUpInside];
        self.amount = 0;
    }
    return self;
}

- (void)awakeFromNib {
    
    //Do anything that depends on the element's symbol
    
    [self setTitle:self.symbol forState:UIControlStateNormal];
    if ([self.symbol length] > 2) {
        self.titleLabel.font = [UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontFour];
    } else {
        self.titleLabel.font = [UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontThree];
    }
}

- (void)elementSelect {
    AppDataObject *appData = [AppDataObject sharedInstance];
    if (![appData.currentElementArray containsObject:self]) {
        [appData.currentElementArray addObject:self];
        self.amount = 1;
    } else {
        self.amount += 1;
    }
    
    [appData.viewController.mathView updateMath];
    appData.viewController.hasSelectedElement = YES;
    [UIView animateWithDuration: 0.2
                          delay: 0.0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations: ^{
                         self.backgroundColor = [UIColor colorWithRed:0.980 green:0.404 blue:0.373 alpha:1];
                     }
                     completion: ^(BOOL done){}];
    
    //Change the badge property's visibility and it's amount
}

- (void)elementDeselect {
    AppDataObject *appData = [AppDataObject sharedInstance];
    [appData.currentElementArray removeObjectIdenticalTo:self];
    appData.viewController.hasDeselectedElement = YES;
    self.amount = 0;
    [UIView animateWithDuration: 0.2
                     animations: ^{
                         self.backgroundColor = [UIColor colorWithRed:0.196 green:0.208 blue:0.259 alpha:1];
                     }];
    
    //Hide the badge property
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
