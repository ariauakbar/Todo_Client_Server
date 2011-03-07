//
//  addNewSubjectView.m
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/7/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import "addNewSubjectView.h"
#import "RootViewController.h"


@implementation addNewSubjectView
@synthesize delegate;
@synthesize newSubjectContainer;
@synthesize textView;
@synthesize textFieldSubject;
@synthesize toolbar;


- (void)dealloc {
	[toolbar release];
	[textFieldSubject release];
	[textView release];
	[newSubjectContainer release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		newSubjectContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 205)];
		newSubjectContainer.backgroundColor = [UIColor grayColor];
		
		textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 20.0, 320, 205)];
		textView.delegate = self;
		textView.text = @"put your desc here (delete this sentence first)";
		textView.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
		[newSubjectContainer addSubview:textView];
		
		textFieldSubject = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 30)];
		textFieldSubject.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
		textFieldSubject.placeholder = @"<Subject>";
		textFieldSubject.leftViewMode = UITextFieldViewModeAlways;
		textFieldSubject.userInteractionEnabled = YES;
		textFieldSubject.delegate = self;
		textFieldSubject.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
		textFieldSubject.backgroundColor = [UIColor whiteColor];
		textFieldSubject.adjustsFontSizeToFitWidth = YES;
		textFieldSubject.borderStyle = UITextBorderStyleLine;
		[newSubjectContainer addSubview:textFieldSubject];
		
		[self addSubview:newSubjectContainer];
		
		toolbar = [[UIToolbar alloc] init];
		[toolbar sizeToFit];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		//toolbar.alpha = 0.3f;
		toolbar.frame = CGRectMake(0, 170, 320, 35);
		UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(sendTask)];
		//UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(removeViewAndReloadTableView)];
		NSArray *items = [NSArray arrayWithObject:add];
		[toolbar setItems:items];
		[self.newSubjectContainer addSubview:toolbar];
		
		[add release];
		
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)showView:(BOOL)option {
	
	[self.textFieldSubject becomeFirstResponder];
	
	CGRect thisFrame = self.newSubjectContainer.frame;
	CGSize containerSize = [self.newSubjectContainer sizeThatFits:CGSizeZero];
	CGRect hide = CGRectMake(0.0, thisFrame.origin.y + containerSize.height, containerSize.width, containerSize.height);
	CGRect show = CGRectMake(0.0, 0.0, containerSize.width, containerSize.height);
	//self.newSubjectContainer.frame = show;
	
	if (option) {
		
		self.newSubjectContainer.frame = hide;
		[self.delegate putAddNewSubjectViewToWindow:self];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2f];
	//[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	
	if (option) {
		
		self.newSubjectContainer.frame = show;
		
	} else {
		
		[UIView setAnimationDidStopSelector:@selector(removeViewAndReloadTableView)];
		self.newSubjectContainer.frame = hide;
	}
    
	[UIView commitAnimations];
}

-(void)removeViewAndReloadTableView {
	
	textFieldSubject.text = @"";
	textView.text = @"put your desc here (delete this sentence first)";
	
	
	[self removeFromSuperview];
	[self.delegate reloadView];
	//[self.delegate reloadTableView];
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url {
	url = [url stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	NSString *encodedUrl = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8);
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	[request setURL:[NSURL URLWithString:encodedUrl]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:20];
	[request setHTTPShouldHandleCookies:FALSE];
	[encodedUrl release];
	
	return request;
}

-(void)sendTask {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSString *url = [[NSString alloc] initWithString:@"http://localhost:3000/tasks"];
	//NSString *commit = [[NSString alloc] initWithString:@"Create Task"];
	//NSString *token = [[NSString alloc] initWithString:@"gYzks4C0Q6l1hNcdhjJmFbL0NhqSucfmmQo8aom2Lxw="];
	NSString *body = [[NSString alloc] initWithFormat:@"task[subject]=%@&task[desc]=%@", textFieldSubject.text, textView.text];
	
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setHTTPMethod:@"POST"];
	if (body) {
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSURLConnection *connect = [[NSURLConnection alloc] init];
	[connect initWithRequest:request delegate:self];
	[url release];
	[body release];
	//[token release];
//	[commit release];
	[connect release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self removeViewAndReloadTableView];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"eerrroro");
}


@end
