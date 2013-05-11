//
//  BBUFileListViewController.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUFileListViewController.h"
#import "BBUFilesViewController.h"
#import "BBUGitHubRepo.h"
#import "BBUProjectNavigator.h"
#import "EXTScope.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

static NSString* const kCellId = @"RepoCell";

@interface BBUFileListViewController ()

@property (nonatomic, strong) BBUProjectNavigator* navigator;

@end

#pragma mark -

@implementation BBUFileListViewController

-(id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Repos", nil);
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"] && self.navigator.loading == NO) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        [self.tableView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)viewDidLoad {
    self.navigator = [BBUProjectNavigator new];
    [self.navigator addObserver:self forKeyPath:@"loading" options:0 context:NULL];
}

#pragma mark - UITableView data source and delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    BBUGitHubRepo* repo = self.navigator.repos[indexPath.row];
    
    @unsafeify(cell);
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:repo.avatarURL]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       @strongify(cell);
                                       cell.imageView.image = image;
                                       [cell setNeedsLayout];
                                   } failure:nil];
    
    cell.textLabel.text = repo.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBUGitHubRepo* repo = self.navigator.repos[indexPath.row];
    BBUFilesViewController* filesVC = [[BBUFilesViewController alloc] initWithTreeOwner:repo];
    [self.navigationController pushViewController:filesVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.navigator.repos.count;
}

@end
