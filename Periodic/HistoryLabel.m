//
//  HistoryLabel.m
//  Periodic
//
//  Created by James Kolsby on 12/22/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "HistoryLabel.h"
#import "AppDataObject.h"

@implementation HistoryLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.alpha = 0.7;
    }
    return self;
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
