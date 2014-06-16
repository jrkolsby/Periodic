//
//  ViewController.h
//  Periodic
//
//  Created by James Kolsby on 11/12/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet MathView *mathView;
@property (weak, nonatomic) IBOutlet UIView *historyView;

@property (assign) int fontOne;
@property (assign) int fontTwo;
@property (assign) int fontThree;
@property (assign) int fontFour;

@property (assign) BOOL isStatusBarHidden;

@property (retain) NSMutableArray *historyArray;

@property BOOL hasSelectedElement;
@property BOOL hasDeselectedElement;
@property BOOL hasViewedInfo;
@property BOOL hasClearedCompound;
@property BOOL hasViewedHistory;

- (void)addToHistory;
- (void)killElements;
- (void)killElement :(CGPoint)location;

@end
