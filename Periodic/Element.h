//
//  Element.h
//  Periodic
//
//  Created by James Kolsby on 11/17/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Element : UIButton

@property (assign) NSString *symbol;

@property (assign) float percentMass;

@property (assign) int amount;
@property (assign) int historicalAmount;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)awakeFromNib;

- (void)elementSelect;

- (void)elementDeselect;

@end
