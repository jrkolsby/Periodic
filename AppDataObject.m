//
//  AppDataObject.m
//  Periodic
//
//  Created by James Kolsby on 11/30/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "AppDataObject.h"
#import "MathView.h"

@implementation AppDataObject

@synthesize currentElementArray;
@synthesize viewController;

+ (AppDataObject *)sharedInstance {
    static AppDataObject *tempInstance = nil;
    //This will make the object a singleton, and each time sharedInstance is called on the AppDataObject class, a new tempInstance won't be created
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempInstance = [[self alloc] init];
    });
    return tempInstance;
}
- (id)init {
    if (self = [super init]) {
        currentElementArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
