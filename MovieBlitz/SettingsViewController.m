//
//  SettingsViewController.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/9/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize tableView = _tableView;
@synthesize versionLabel = _versionLabel;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.versionLabel.text = @"Version 1.0 beta 1";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Game Settings";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabel.text = @"Sounds";
        
        UISwitch *onoff = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 8.0, 80.0, 45.0)];
        
        [onoff addTarget:self action:@selector(flip:) forControlEvents:UIControlEventValueChanged];
        

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [onoff setOn:[[defaults stringForKey:@"sounds"] isEqualToString:@"on"]];
        
        [cell.contentView addSubview:onoff];
        
      }  
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

}

- (IBAction)clickDoneButton {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)flip:(UISwitch*)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *switchvalue = ([sender isOn]) ? @"on" : @"off";
    
    [defaults setObject:switchvalue forKey:@"sounds"];

}

@end
