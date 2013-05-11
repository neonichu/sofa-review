//
//  BBUFilesViewController.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUFilesViewController.h"
#import "BBUGitHubRepo.h"
#import "BBUGitHubTreeNode.h"
#import "BBUNotifications.h"
#import "MBProgressHUD.h"

static NSString* const kCellId = @"FileCell";

@interface BBUFilesViewController ()

@property (nonatomic, strong) BBUGitHubRepo* repo;
@property (nonatomic, strong) NSArray* treeNodes;

@end

#pragma mark -

@implementation BBUFilesViewController

-(id)initWithRepo:(BBUGitHubRepo*)repo {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Files", nil);
        
        self.repo = repo;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:animated];
    
    [self.repo fetchTreeForLatestCommitWithCompletionBlock:^(NSArray *treeNodes) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:animated];
        
        self.treeNodes = treeNodes;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView data source and delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    BBUGitHubTreeNode* node = self.treeNodes[indexPath.row];
    cell.textLabel.text = node.path;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBUGitHubTreeNode* node = self.treeNodes[indexPath.row];
    
    if (node.type != GHTreeNodeType_Blob) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    //NSLog(@"Fetching content for URL: %@", node.url);
    
    [BBUGitHubRepo scheduleRequestWithURL:node.url
                              withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                                  
                                  NSString* encoding = responseObject[@"encoding"];
                                  if (![encoding isEqualToString:@"base64"]) {
                                      NSLog(@"Content isn't base64 encoded. Too bad.");
                                      return;
                                  }
                                  
                                  NSString* content = responseObject[@"content"];
                                  content = [content base64DecodedString];
                                  
                                  if (!content) {
                                      NSLog(@"No content, probably binary.");
                                      return;
                                  }
                                  
                                  [[NSNotificationCenter defaultCenter]
                                   postNotificationName:kBBUSourceCodeTextReceivedNotification
                                   object:nil userInfo:@{ kCode: content, kTreeNode: node }];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [UIAlertView bbu_showAlertWithError:error];
                              }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.treeNodes.count;
}

@end
