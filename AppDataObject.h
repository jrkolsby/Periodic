//
//  AppDataObject.h
//  Periodic
//
//  Created by James Kolsby on 11/30/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathView.h"
#import "ViewController.h"

@interface AppDataObject : NSObject {
    NSMutableArray *currentElementArray;
    ViewController *viewController;
}

@property (nonatomic, retain) NSMutableArray *currentElementArray;
@property (nonatomic, retain) ViewController *viewController;

+ (AppDataObject*)sharedInstance;

@end
