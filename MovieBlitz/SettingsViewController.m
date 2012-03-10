//
//  SettingsViewController.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/9/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize versionLabel = _versionLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.versionLabel.text = @"Version 1.0 beta 1";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Game Settings";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabel.text = @"Sounds";
        
        UISwitch *onoff = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 16.0, 80.0, 27.0)];
        
        [onoff addTarget:self action:@selector(flipAudioSwitch:) forControlEvents:UIControlEventValueChanged];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [onoff setOn:[[defaults stringForKey:@"sounds"] isEqualToString:@"on"]];
        
        [cell.contentView addSubview:onoff];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.textLabel.text = @"Difficulty";
        
        UISegmentedControl *difficultySegmentedControl = 
        [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Easy",@"Hard",nil]];
                                                          
        [difficultySegmentedControl setFrame:CGRectMake(155.0, 8.0, 140.0, 43.0)];        
        [difficultySegmentedControl addTarget:self action:@selector(changeDifficulty:) forControlEvents:UIControlEventValueChanged];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int selectedSegmentIndex = ([[defaults stringForKey:@"difficulty"] isEqualToString:@"hard"]) ? 1 : 0;
        
        [difficultySegmentedControl setSelectedSegmentIndex:selectedSegmentIndex];
        
        [cell.contentView addSubview:difficultySegmentedControl];
        
    }  
    return cell;
}

- (IBAction)flipAudioSwitch:(UISwitch*)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *switchvalue = ([sender isOn]) ? @"on" : @"off";
    
    [defaults setObject:switchvalue forKey:@"sounds"];

    [defaults synchronize];
}

- (IBAction)changeDifficulty:(UISegmentedControl*)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *difficultyValue = ([sender selectedSegmentIndex] == 1) ? @"hard" : @"easy";
    
    [defaults setObject:difficultyValue forKey:@"difficulty"];
    
    [defaults synchronize];
}

- (IBAction)clickDoneButton {
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
