//
//  TaskAppDelegate.m
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/6/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import "TaskAppDelegate.h"
#import "RootViewController.h"

#define TASKS_URL @"http://localhost:3000/tasks.json"

@implementation TaskAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize parser;
@synthesize tasksData;
@synthesize loading;

#pragma mark -
#pragma mark Application lifecycle

- (void)dealloc {
	[loading release];
	[tasksData release];
	[parser release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	self.window.backgroundColor = [UIColor whiteColor];
  	
	[self showLoadingProgress];
	[self loadData];
	
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)showLoadingProgress {
	
	loading = [[UIActivityIndicatorView alloc] init];
	loading.frame = CGRectMake(150, 150	, 20, 20);
	loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	loading.hidesWhenStopped = YES;
	
	[self.window addSubview:loading];
	[loading startAnimating];
	
}

-(void)loadData {
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:TASKS_URL]];
	NSURLConnection *connect = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	if (connect)
		self.tasksData = [NSMutableData data];
	
}



#pragma mark NSURLConnectionDelegate

-(void)cancel:(NSURLConnection *)connection{
	
	self.tasksData = nil;
	[connection cancel];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSInteger status = [(NSHTTPURLResponse *)response statusCode];
	NSLog(@"receive response");
	if(status != 200)
		[self cancel:connection];
	//NSLog(@"response is not 200");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
	NSLog(@"receive data");
	[self.tasksData appendData:data];
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"didFailWithError");
	[self cancel:connection];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"didFinishLoading");
	[loading stopAnimating];
	
	NSString *tasksString = [[[NSString alloc] initWithData:tasksData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"%@", tasksString);
	self.tasksData = nil;
	
	parser = [SBJsonParser new];
	NSArray * tasks = [parser objectWithString:tasksString error:nil];
	
	RootViewController *rootViewController = (RootViewController *) [navigationController.viewControllers objectAtIndex:0];
	rootViewController.tasksArray = [NSArray arrayWithArray:tasks];
	
	[self.window addSubview:navigationController.view];
	
	
	
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}





@end

