//
//  RootViewController.m
//  Task
//
//  Created by Mohamad Ariau Akbar on 3/6/11.
//  Copyright 2011 Techbars.com. All rights reserved.
//

#import "RootViewController.h"

#define TASKS_URL @"http://localhost:3000/tasks.json"

@implementation RootViewController

@synthesize tasksArray, tasksData, newArray;


#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
	[newArray release];
	[tasksArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [self showBarButton];
	self.title = @"Task";
	newSubjectView = [[addNewSubjectView alloc] initWithFrame:CGRectMake(0, 60, 320, 480)];
	newSubjectView.delegate = self;
	
	
}

-(UIBarButtonItem *)showBarButton {
	
	if([newSubjectView superview] == nil){
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask)];
		return addButton;
		[addButton release];
	}else {
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTask)];
		return cancelButton;
		[cancelButton release];
	}
	
}

-(void)addNewTask {
	
	[newSubjectView showView:([newSubjectView superview] == nil)];
	self.navigationItem.rightBarButtonItem = [self showBarButton];
}

-(void)cancelTask {
	
	[newSubjectView showView:([newSubjectView superview] == nil)];
}

-(void)putAddNewSubjectViewToWindow:(UIView *)aView {
	
	[self.navigationController.view addSubview:aView];
}

-(void)reloadView {
	
	[self loadData];
	NSLog(@"reload view");
}

-(void)loadData {
	
	self.navigationItem.rightBarButtonItem = [self showBarButton];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:TASKS_URL]];
	NSURLConnection *connect = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	if (connect)
		self.tasksData = [NSMutableData data];
}

-(void)cancel:(NSURLConnection *)connection{
	
	self.tasksData = nil;
	[connection cancel];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSInteger status = [(NSHTTPURLResponse *)response statusCode];
	NSLog(@"receive response 2");
	if(status != 200)
		[self cancel:connection];
	//NSLog(@"response is not 200");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
	NSLog(@"receive data 2");
	[self.tasksData appendData:data];
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"didFailWithError 2");
	[self cancel:connection];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"didFinishLoading 2");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString *tasksString = [[[NSString alloc] initWithData:tasksData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"DATA 2 %@", tasksString);
	self.tasksData = nil;
	
	parser = [SBJsonParser new];
	NSArray *loadedTask = [parser objectWithString:tasksString error:nil];
	
	self.tasksArray = [NSArray arrayWithArray:loadedTask];
	
	for (int i = 0; i < tasksArray.count; i++) {
		
		NSLog(@"%@", [tasksArray objectAtIndex:i]);
	}
	
	[self.tableView reloadData];
	
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return tasksArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	NSLog(@"%d", newArray.count);
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [[[tasksArray objectAtIndex:indexPath.row] objectForKey:@"task"] objectForKey:@"subject"];
  
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = @"Task";
	
	return title;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

