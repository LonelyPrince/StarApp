 //
//  RendererTableViewController.m
//  DLNASample
//
//  Created by 健司 古山 on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RendererTableViewController.h"
#import "AppDelegate.h"
#import <CyberLink/UPnPAV.h>
#import "UPnPDeviceTableViewCell.h"

@interface RendererTableViewController ()

@end

@implementation RendererTableViewController
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAvController:(CGUpnpAvController*)aController
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.dataSource = [aController renderers];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //  self.title = NSLocalizedString(@"DLNA Server", @"Master");
    self.title = @"dmr";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
#else
    static NSString *CELLID = @"upnprootobj";
	
	UPnPDeviceTableViewCell *cell = (UPnPDeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELLID];
	if (cell == nil) {
		cell =      [[UPnPDeviceTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CELLID];
	}
	
	int row = [indexPath indexAtPosition:1];	
	if (row < [self.dataSource count]) {
		CGUpnpDevice *device = [self.dataSource objectAtIndex:row];
		[cell setDevice:device];
	}
    
	return cell;
#endif
}

////////////

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate* appDelagete = [[UIApplication sharedApplication] delegate];
    appDelagete.avRenderer = (CGUpnpAvRenderer*)[self.dataSource objectAtIndex:indexPath.row];
   
}

@end
