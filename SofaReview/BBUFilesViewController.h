//
//  BBUFilesViewController.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBUGitHubRepo;

@interface BBUFilesViewController : UITableViewController

-(id)initWithRepo:(BBUGitHubRepo*)repo;

@end
