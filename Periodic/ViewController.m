//
//  ViewController.m
//  Periodic
//
//  Created by James Kolsby on 11/12/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "ViewController.h"
#import "Element.h"
#import "AppDataObject.h"
#import "MathView.h"
#import "HistoryLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

NSTimer *tutorialTimer;

@synthesize historyArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasFinishedTutorial"]) {
        
        //Make touch circles
        for (int i = 1; i < 3; i++) {
            UIView *tutorialTouch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fontOne, self.fontOne)];
            tutorialTouch.backgroundColor = [UIColor whiteColor];
            tutorialTouch.alpha = 0;
            tutorialTouch.layer.cornerRadius = self.fontOne / 2;
            tutorialTouch.layer.masksToBounds = YES;
            tutorialTouch.tag = i + 10;
            [self.view addSubview:tutorialTouch];
        }
        
        self.hasSelectedElement = NO;
        self.hasDeselectedElement = NO;
        self.hasViewedInfo = NO;
        self.hasClearedCompound = NO;
        self.hasViewedHistory = NO;
        
        [self checkTutorialStatus];
        tutorialTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkTutorialStatus) userInfo:nil repeats:YES];
    }
    
    //Hide status bars on iPhones
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)checkTutorialStatus {
    
    //Create function to move touches during tutorial
    void (^moveTouches)(CGPoint, CGPoint, int) = ^(CGPoint start, CGPoint finish, int num) {
        [[self view] viewWithTag:11].frame = CGRectMake(start.x, start.y,
                                                        [[self view] viewWithTag:11].frame.size.width,
                                                        [[self view] viewWithTag:11].frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            [[self view] viewWithTag:11].alpha = 0.9;
        }];
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self view] viewWithTag:11].frame = CGRectMake(finish.x, finish.y,
                                                            [[self view] viewWithTag:11].frame.size.width,
                                                            [[self view] viewWithTag:11].frame.size.height);
        } completion:^(BOOL completed) {
            [UIView animateWithDuration:0.2 animations:^{
                [[self view] viewWithTag:11].alpha = 0;
            }];
        }];
        if (num > 1) {
            [[self view] viewWithTag:12].frame = CGRectMake(start.x + 100, start.y,
                                                            [[self view] viewWithTag:12].frame.size.width,
                                                            [[self view] viewWithTag:12].frame.size.height);
            [UIView animateWithDuration:0.2 animations:^{
                [[self view] viewWithTag:12].alpha = 0.9;
            }];
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self view] viewWithTag:12].frame = CGRectMake(finish.x + 100, finish.y,
                                                                [[self view] viewWithTag:12].frame.size.width,
                                                                [[self view] viewWithTag:12].frame.size.height);
            } completion:^(BOOL completed) {
                [UIView animateWithDuration:0.2 animations:^{
                    [[self view] viewWithTag:12].alpha = 0;
                }];
            }];
        }
    };
    
    //Check and execute each stage of the tutorial
    CGPoint tableOrigin = CGPointMake(self.mainContainer.frame.origin.x+self.tableView.frame.origin.x,
                                       self.mainContainer.frame.origin.y+self.tableView.frame.origin.y);
    if (!self.hasSelectedElement) {
        moveTouches(CGPointMake([self.tableView viewWithTag:2].frame.origin.x + tableOrigin.x + (([self.tableView viewWithTag:2].frame.size.width - self.fontOne) / 2),
                                [self.tableView viewWithTag:2].frame.origin.y + tableOrigin.y + (([self.tableView viewWithTag:2].frame.size.height - self.fontOne) / 2)),
                    CGPointMake([self.tableView viewWithTag:2].frame.origin.x + tableOrigin.x + (([self.tableView viewWithTag:2].frame.size.width - self.fontOne) / 2),
                                [self.tableView viewWithTag:2].frame.origin.y + tableOrigin.y + (([self.tableView viewWithTag:2].frame.size.height - self.fontOne) / 2)), 1);
    } else {
        if (!self.hasDeselectedElement) {
            Element *selectedElement = [[AppDataObject sharedInstance].currentElementArray objectAtIndex:0];
            moveTouches(CGPointMake(selectedElement.frame.origin.x + tableOrigin.x + (([self.tableView viewWithTag:2].frame.size.width - self.fontOne) / 2),
                                    selectedElement.frame.origin.y + tableOrigin.y),
                        CGPointMake(selectedElement.frame.origin.x + tableOrigin.x + (([self.tableView viewWithTag:2].frame.size.width - self.fontOne) / 2),
                                    100 + selectedElement.frame.origin.y + tableOrigin.y), 1);
        } else {
            if (!self.hasViewedInfo) {
                if ([self.mathView.chemicalFormulaLabel.text isEqualToString:@""]) {
                    [(Element *)[self.tableView viewWithTag:1] elementSelect];
                    for (int i = 0; i < 2; i++) {
                        [(Element *)[self.tableView viewWithTag:1] elementSelect];
                        [(Element *)[self.tableView viewWithTag:2] elementSelect];
                        [(Element *)[self.tableView viewWithTag:3] elementSelect];
                    }
                }
                moveTouches(CGPointMake(tableOrigin.x + self.mathView.frame.origin.x + ((self.mathView.frame.size.width - self.fontOne) / 2),
                                        tableOrigin.y + self.mathView.frame.origin.y + ((self.mathView.frame.size.height - self.fontOne) / 2)),
                            CGPointMake(tableOrigin.x + self.mathView.frame.origin.x + ((self.mathView.frame.size.width - self.fontOne) / 2),
                                        200 + tableOrigin.y + self.mathView.frame.origin.y + ((self.mathView.frame.size.height - self.fontOne) / 2)), 1);
            } else {
                if (!self.hasClearedCompound) {
                    moveTouches(CGPointMake((([self view].bounds.size.width - self.fontOne) / 2) - 50,
                                            ([self view].bounds.size.height - self.fontOne) / 2),
                                CGPointMake((([self view].bounds.size.width - self.fontOne) / 2) - 50,
                                            (([self view].bounds.size.height - self.fontOne) / 2) + 100), 2);
                } else {
                    if (!self.hasViewedHistory) {
                        moveTouches(CGPointMake(([self view].bounds.size.width - self.fontOne) / 2,
                                                ([self view].bounds.size.height - self.fontOne) / 2),
                                    CGPointMake(([self view].bounds.size.width - self.fontOne) / 2,
                                                (([self view].bounds.size.height - self.fontOne) / 2) - 100), 1);
                    } else {
                        
                        //Set user default after tutorial has been completed once
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasFinishedTutorial"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[[self view] viewWithTag:12] removeFromSuperview];
                        [[[self view] viewWithTag:12] removeFromSuperview];

                        [tutorialTimer invalidate];
                    }
                }
            }
        }
    }
}

- (void)awakeFromNib {
    /*
      The viewcontroller has to be added to the
      AppDataObject after it is launched by the
      storyboard, not after viewDidLoad. This is
      to preserve the user runtime attributes.
    */
    
    [AppDataObject sharedInstance].viewController = self;
    self.historyView.alpha = 0;
    self.historyArray = [[NSMutableArray alloc] init];
}

- (void)killElements {
    if ([[AppDataObject sharedInstance].currentElementArray count] > 0) {
        
        //Can't delete an object while iterating
        NSArray *newCurrentElementArray = [[NSArray alloc] initWithArray:[AppDataObject sharedInstance].currentElementArray];
        
        for (Element *currentElement in newCurrentElementArray) {
            currentElement.historicalAmount = currentElement.amount;
            [currentElement elementDeselect];
        }
        
        [self.mathView updateMath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        
        //History is hidden, downward gestures enabled
        
        [scrollView setContentOffset: CGPointMake(0, 0)];
        
        UIPanGestureRecognizer *panGesture = scrollView.panGestureRecognizer;
        
        CGPoint velocity = [panGesture velocityInView:scrollView];
        
        NSInteger count = [panGesture numberOfTouches];
        
        if (count == 2 && velocity.y > 20 && [[AppDataObject sharedInstance].currentElementArray count] > 0) {
            
            //Kill all elements
            [self addToHistory];
            [self killElements];
            
            self.hasClearedCompound = YES;
        }
        
        if (count == 1 && velocity.y > 20) {
            
            //Subtract touch displacement from current position to get the initial CGPoint
            CGPoint initialPoint = CGPointMake([panGesture locationInView:scrollView].x - [panGesture translationInView:scrollView].x,
                                               [panGesture locationInView:scrollView].y - [panGesture translationInView:scrollView].y);
            
            if (initialPoint.x > self.mathView.frame.origin.x &&
                initialPoint.x < self.mathView.frame.origin.x + self.mathView.frame.size.width &&
                initialPoint.y > self.mathView.frame.origin.y &&
                initialPoint.y < self.mathView.frame.origin.y + self.mathView.frame.size.height &&
                [[AppDataObject sharedInstance].currentElementArray count] > 0) {
                
                [self addToHistory];
                
                float percentScrolled = [panGesture translationInView:scrollView].y / self.tableView.frame.size.height;
                
                self.mathViewHeight.constant = self.mathView.initialHeight + [panGesture translationInView:scrollView].y;
                self.mathView.shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:self.mathView.bounds] CGPath];
                
                self.mathView.chemicalInfoLabel.alpha = 2 * percentScrolled;
                self.mathView.shadowLayer.shadowOpacity = 2 * percentScrolled;
                self.mathView.chemicalInfoLabel.frame = CGRectMake(self.mathView.chemicalInfoLabel.frame.origin.x,
                                                              self.mathView.chemicalInfoLabelInitialY + (50 * percentScrolled),
                                                              self.mathView.chemicalInfoLabel.frame.size.width,
                                                              self.mathView.chemicalInfoLabel.frame.size.height);
                
                if ([panGesture translationInView:scrollView].y > 80) {
                    self.hasViewedInfo = YES;
                }
                
            } else {
                [self killElement:initialPoint];
            }
        }
        
    } else {
        
        //Calculate percent scrolled
        float percentScrolled = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.size.height);
        
        [self.tableView setAlpha: -0.7 * percentScrolled + 1];
        [self.historyView setAlpha:percentScrolled * percentScrolled];
        
        if (scrollView.contentOffset.y > 80) {
            self.hasViewedHistory = YES;
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.mathView.frame.size.height > self.mathView.initialHeight) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.mathViewHeight.constant = self.mathView.initialHeight;
                             self.mathView.chemicalInfoLabel.alpha = 0;
                             self.mathView.chemicalInfoLabel.frame = CGRectMake(self.mathView.chemicalInfoLabel.frame.origin.x,
                                                                                self.mathView.chemicalInfoLabelInitialY,
                                                                                self.mathView.chemicalInfoLabel.frame.size.width,
                                                                                self.mathView.chemicalInfoLabel.frame.size.height);

                         }];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
        animation.duration = 0.4;
        [self.mathView.shadowLayer addAnimation:animation forKey:@"shadowOpacity"];
        self.mathView.shadowLayer.shadowOpacity = 0.0;
        
    }
}

- (void)killElement :(CGPoint)location {
    if ([[AppDataObject sharedInstance].currentElementArray count] > 0) {
        
        //Can't delete an object while iterating currentElementArray, so iterate a copy of it
        NSArray *newCurrentElementArray = [[NSArray alloc] initWithArray:[AppDataObject sharedInstance].currentElementArray];
        
        for (Element *currentElement in newCurrentElementArray) {
            
            //Check if touch location is inside the bounds of any selected elements
            if (location.x > currentElement.frame.origin.x + self.tableView.frame.origin.x &&
                location.x < currentElement.frame.origin.x + self.tableView.frame.origin.x + currentElement.frame.size.width &&
                location.y > currentElement.frame.origin.y + self.tableView.frame.origin.y &&
                location.y < currentElement.frame.origin.y + self.tableView.frame.origin.y + currentElement.frame.size.height) {
                [currentElement elementDeselect];
                [self.mathView updateMath];
            }
        }
    }
}

- (void)addToHistory {
    
    BOOL shouldAdd = NO;
    if (![self.mathView.chemicalFormulaLabel.text isEqualToString:@""]) {
        if ([self.historyArray count] > 0) {
            if (![[[self.historyArray objectAtIndex:0] objectForKey:@"string"] isEqualToString:self.mathView.chemicalFormulaLabel.text]) {
                shouldAdd = YES;
            }
        } else {
            shouldAdd = YES;
        }
    }
    
    if (shouldAdd) {
        
        //Add new compound dictionary to the the historyArray
        //Need to make a copy of the elements in currentElementArray to preserve amount variable
        NSArray *currentElementArray = [[NSArray alloc] initWithArray:[AppDataObject sharedInstance].currentElementArray];
        
        NSDictionary *newHistoryObject = [[NSDictionary alloc] initWithObjectsAndKeys:currentElementArray, @"array", self.mathView.chemicalFormulaLabel.text, @"string", nil];
        [self.historyArray insertObject:newHistoryObject atIndex:0];
        
        //Remove old historyLabel(s)
        for(UIView *subview in [self.historyView subviews]) {
            [subview removeFromSuperview];
        }
        
        //Create new historyLabel(s) from historyArray
        float currentX = 0.0;
        int i = 0;
        for (NSDictionary *currentDict in self.historyArray) {
            HistoryLabel *historyLabel = [[HistoryLabel alloc] init];
            historyLabel.text = [currentDict objectForKey:@"string"];
            if (historyLabel.text.length < 14) {
                historyLabel.font = [UIFont fontWithName:@"compound-bold" size:self.fontOne];
            } else if (historyLabel.text.length >= 14) {
                historyLabel.font = [UIFont fontWithName:@"compound-bold" size:self.fontTwo];
            }
            historyLabel.elementArray = [currentDict objectForKey:@"array"];
            [historyLabel sizeToFit];
            historyLabel.frame = CGRectMake(currentX, 0, historyLabel.frame.size.width + 40, self.historyView.frame.size.height);
            currentX += historyLabel.frame.size.width;
            if (currentX <= self.historyView.frame.size.width || i == 0) {
                [self.historyView addSubview:historyLabel];
            }
            i++;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.historyArray removeAllObjects];
}

@end