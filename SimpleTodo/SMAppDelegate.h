//
//  SMAppDelegate.h
//  SimpleTodo
//
//  Created by Steve Moser on 1/26/12.
//  Copyright (c) 2012 MetaEdged. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMViewController;

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SMViewController *viewController;

@end
