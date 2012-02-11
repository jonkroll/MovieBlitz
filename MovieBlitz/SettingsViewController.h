//
//  SettingsViewController.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/9/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

- (IBAction)clickDoneButton;

@end
