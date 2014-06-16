//
//  Table.m
//  Periodic
//
//  Created by James Kolsby on 12/7/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "Table.h"
#import "AppDataObject.h"
#import "MathView.h"
#import "HistoryLabel.h"
#import "element.h"

@implementation Table

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.panGestureRecognizer setMaximumNumberOfTouches:1];
        [self.panGestureRecognizer setMinimumNumberOfTouches:1];
    }
    return self;
}

- (void)awakeFromNib {
    [self setDelegate:[AppDataObject sharedInstance].viewController];
    
    //Add historyTap action to Table's tapGestureRecognizer
    UITapGestureRecognizer *historyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyTap:)];
    [historyTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:historyTap];
}

//ScrollView tap manager, as opposed to the drag manager in the ViewController delegate
- (void)historyTap :(UIGestureRecognizer *)gestureRecognizer {
    CGPoint tapLocation = [gestureRecognizer locationInView:[AppDataObject sharedInstance].viewController.historyView];
    for (HistoryLabel *historyLabel in [[AppDataObject sharedInstance].viewController.historyView subviews]) {
        if (tapLocation.x > historyLabel.frame.origin.x &&
            tapLocation.x < historyLabel.frame.origin.x + historyLabel.frame.size.width &&
            tapLocation.y > historyLabel.frame.origin.y &&
            tapLocation.y < historyLabel.frame.origin.y + historyLabel.frame.size.height) {
            
            //Select the history view's elements
            [[AppDataObject sharedInstance].viewController killElements];
            for (Element *currentElement in historyLabel.elementArray) {
                for (int i = 0; i < currentElement.historicalAmount; i++) {
                    [currentElement elementSelect];
                }
            }
            
            //Animate the UIScrollView
            [UIView animateWithDuration:0.3 animations:^{
                [self setContentOffset:CGPointMake(0, 0)];
            }];
            
        }
    }
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
