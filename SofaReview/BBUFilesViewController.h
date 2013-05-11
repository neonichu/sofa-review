//
//  BBUFilesViewController.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBUGitHubTreeOwner;

@interface BBUFilesViewController : UITableViewController

-(id)initWithTreeOwner:(BBUGitHubTreeOwner*)treeOwner;

@end
