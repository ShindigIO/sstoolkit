//
//  SSRatingPickerViewController.m
//  SSToolkit
//
//  Created by Sam Soffes on 2/3/11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "SSRatingPickerViewController.h"
#import "SSRatingPickerScrollView.h"
#import "SSRatingPicker.h"
#import "SSTextField.h"
#import "SSTextView.h"
#import "UIScreen+SSToolkitAdditions.h"

@interface SSRatingPickerViewController ()
@property (nonatomic, strong) SSRatingPickerScrollView *scrollView;
@end

@implementation SSRatingPickerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Accessors

- (SSRatingPicker *)ratingPicker {
	return self.scrollView.ratingPicker;
}


- (SSTextField *)titleTextField {
	return self.scrollView.titleTextField;
}


- (SSTextView *)reviewTextView {
	return self.scrollView.reviewTextView;
}


#pragma mark - UIViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	SSRatingPickerScrollView* scroll = [[SSRatingPickerScrollView alloc] initWithFrame:[self.view bounds]];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.scrollView = scroll;
    [self.view addSubview:self.scrollView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.titleTextField becomeFirstResponder];
}


#pragma mark - SSViewController

- (void)layoutViewsWithOrientation:(UIInterfaceOrientation)orientation {
	
	CGSize size = [[UIScreen mainScreen] boundsForOrientation:orientation].size;
	BOOL landscape = UIInterfaceOrientationIsLandscape(orientation);
	size.height -= landscape ? 214.0f : 280.0f;
	
	self.view.frame = CGRectMake(0.0f, 0.0f, size.width, size.height - 10.0f);
}

#pragma mark - Keyboard


- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.scrollView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    self.scrollView.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}


@end
