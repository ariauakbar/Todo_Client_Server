//
//  addNewSubjectView.h
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/7/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// delegate protocol
@protocol addNewSubjectViewDelegate
@optional
	-(void)putAddNewSubjectViewToWindow:(UIView *)aView;
	-(void)reloadView;
@end

@interface addNewSubjectView : UIView <UITextViewDelegate, UITextFieldDelegate> {

	id<addNewSubjectViewDelegate> delegate;
	UIView *newSubjectContainer;
	UITextView *textView;
	UITextField *textFieldSubject;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) id<addNewSubjectViewDelegate> delegate;
@property (nonatomic, retain) UIView *newSubjectContainer;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *textFieldSubject;
@property (nonatomic, retain) UIToolbar *toolbar;


-(void)showView:(BOOL)option;
-(void)removeViewAndReloadTableView;
-(void)sendTask;


@end


