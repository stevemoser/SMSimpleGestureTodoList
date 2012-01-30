//
//  SMTodoTableView.m
//  SimpleTodo
//
//  Created by Steve Moser on 1/26/12.
//  Copyright (c) 2012 MetaEdged. All rights reserved.
//

#import "SMTodoTableView.h"

static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";

const NSInteger kViewTag = 1;

@implementation SMTodoTableView

@synthesize todos,textFieldNormal,isListOfLists;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization


    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
   
    if ([self todos] == nil) {
        todos = [[NSMutableArray alloc] init];
        if ([self isListOfLists]) {
            [todos addObject:@"Due today"];
            [todos addObject:@"Overdue"];
            [todos addObject:@"Grocery List"];
        }
        else {
            [todos addObject:@"Milk"];
            [todos addObject:@"Cereal"];
            [todos addObject:@"Bananas"];
            [todos addObject:@"Cocoa"];
        }
    }
    
    //add footer to prevent emtpy cells from drawing
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = view;
        
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    
    [gestureRecognizer setDelegate:self];
    [[self tableView] addGestureRecognizer:gestureRecognizer];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Gesture Methods

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if ([gestureRecognizer velocity] > 0) { //zoom in
            if ([self isListOfLists]) {
                SMTodoTableView *svc = [[SMTodoTableView alloc] init];
                [svc setIsListOfLists:NO];
                [self.navigationController pushViewController:svc animated:YES];
            }
            else { //if in normal list view create a new todo
                CGPoint pinchLocation = [gestureRecognizer locationInView:self.tableView];
                NSIndexPath *newPinchedIndexPath = [self.tableView indexPathForRowAtPoint:pinchLocation];
                
                [self.todos insertObject:@"Pinch" atIndex:newPinchedIndexPath.row];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else { //zoom out
            if (![self isListOfLists]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
        
}

#pragma mark - TableViewController Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [todos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Configure the cell...
//    
//    return cell
    
    static NSString *kCellIdentifier = @"Cell";

    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    
            
    }
    else {
//        UIView *viewToCheck = nil;
//        viewToCheck = [cell.contentView view viewWithTag:indexPath.row];//kViewTag];
//        //if (viewToCheck)
//            [viewToCheck removeFromSuperview];
        for (int i = [cell.contentView.subviews count] -1; i>=0; i--) {
            if ([[cell.contentView.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
                [[cell.contentView.subviews objectAtIndex:i] removeFromSuperview];
            }
        }
    }
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 18, 320, 40)];
    
    if ([todos objectAtIndex:indexPath.row]!=nil) {
        textField.text = [todos objectAtIndex:indexPath.row];
    }
    
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont boldSystemFontOfSize:20];
    textField.backgroundColor = [UIColor clearColor];
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo; 
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.textAlignment = UITextAlignmentLeft;
    textField.tag = indexPath.row;
    textField.delegate = self;
    
    textField.clearButtonMode = UITextFieldViewModeNever;
    [textField setEnabled: YES];
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [cell.contentView addSubview:textField];

    
    return cell; 
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 

}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
    [self.todos replaceObjectAtIndex:textField.tag withObject:textField.text];
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = sender;
    
    [self.todos replaceObjectAtIndex:textField.tag withObject:textField.text];

}

#pragma mark -
#pragma mark Text Fields

- (void)refreshHeader {
    [self.todos insertObject:@"Pull From Top" atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self performSelector:@selector(stopLoadingHeader) withObject:nil afterDelay:0.1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textField;
    for (int i = [cell.contentView.subviews count] -1; i>=0; i--) {
        if ([[cell.contentView.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            textField = [cell.contentView.subviews objectAtIndex:i];
        }
    }
    if (textField) {
        [textField becomeFirstResponder];
    }

}

- (void)refreshFooter {
    [self.todos addObject:@"Pull From Bottom"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self performSelector:@selector(stopLoadingFooter) withObject:nil afterDelay:0.1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([[self todos] count] -1) inSection:0]];
    UITextField *textField;
    for (int i = [cell.contentView.subviews count] -1; i>=0; i--) {
        if ([[cell.contentView.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            textField = [cell.contentView.subviews objectAtIndex:i];
        }
    }
    if (textField) {
        [textField becomeFirstResponder];
    }
    
}

@end
