//
//  SMTodoTableView.h
//  SimpleTodo
//
//  Created by Steve Moser on 1/26/12.
//  Copyright (c) 2012 MetaEdged. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface SMTodoTableView : PullRefreshTableViewController <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, retain, readonly) UITextField	*textFieldNormal;

@property (nonatomic,strong) NSMutableArray* todos;

@property (nonatomic,assign) BOOL isListOfLists;

@end
