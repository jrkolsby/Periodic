//
//  MathView.h
//  Periodic
//
//  Created by James Kolsby on 12/1/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathView : UIView

- (void)updateMath;

@property (assign) UILabel *chemicalFormulaLabel;
@property (assign) UILabel *massLabel;
@property (assign) UILabel *chemicalInfoLabel;

@property (assign) float initialHeight;
@property (assign) float chemicalInfoLabelInitialY;
@property (assign) float chemicalInfoLabelInitialWidth;
@property (assign) CALayer *shadowLayer;


@end
