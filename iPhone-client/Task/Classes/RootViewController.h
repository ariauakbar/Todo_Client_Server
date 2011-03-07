//
//  RootViewController.h
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/6/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addNewSubjectView.h"
#import "JSON.h"

@interface RootViewController : UITableViewController <addNewSubjectViewDelegate> {
	
	NSArray *tasksArray;
	addNewSubjectView *newSubjectView;
@private	
	NSMutableData *tasksData;
	SBJsonParser *parser;
	NSMutableArray *newArray;
	
}

@property (nonatomic, retain) NSArray *tasksArray;
@property (nonatomic, retain) NSMutableData *tasksData;
@property (nonatomic, retain) NSMutableArray *newArray;

-(void)loadData;
-(void)addNewTask;
-(UIBarButtonItem *)showBarButton;


@end
