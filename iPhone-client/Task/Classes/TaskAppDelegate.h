//
//  TaskAppDelegate.h
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/6/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "addNewSubjectView.h"

@interface TaskAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, addNewSubjectViewDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	UIActivityIndicatorView *loading;
	
@private
	NSMutableData *tasksData;
	SBJsonParser *parser;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableData *tasksData;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic, retain) UIActivityIndicatorView *loading;

-(void)loadData;
-(void)showLoadingProgress;
@end

