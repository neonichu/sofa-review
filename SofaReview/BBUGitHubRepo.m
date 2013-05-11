//
//  BBUGitHubRepo.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"

#import "BBUGitHubRepo.h"
#import "BBUGitHubTreeNode.h"

@interface BBUGitHubRepo ()

@property (nonatomic, strong) NSURL* avatarURL;
@property (nonatomic, strong) NSURL* commitsURL;
@property (nonatomic, strong) NSString* fullName;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSURL* treesURL;

@end

#pragma mark -

@implementation BBUGitHubRepo

-(NSString*)dropShaFromURLString:(NSString*)searchText {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{.*\\}" options:0 error:&error];
    if (!regex) {
        NSLog(@"Error creating regex: %@", error.localizedDescription);
        return nil;
    }
    
    return [regex stringByReplacingMatchesInString:searchText
                                           options:0
                                             range:NSMakeRange(0, [searchText length])
                                      withTemplate:@""];
}

-(void)fetchCommits {
    [[self class] scheduleRequestWithURL:self.commitsURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"Success: %@", responseObject);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Fail: %@", error.localizedDescription);
                             }];
}

//commit, tree, url

-(void)fetchTree {
    [[self class] scheduleRequestWithURL:self.treesURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"Success: %@", responseObject);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Fail: %@", error.localizedDescription);
                             }];
}


-(void)fetchTreeWithCompletionBlock:(BBURecvTreeBlock)block {
    [[self class] scheduleRequestWithURL:self.commitsURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSDictionary* commit = responseObject[0][@"commit"];
                                 
                                 // This seems silly
                                 self.commitSha = [[commit[@"url"] componentsSeparatedByString:@"/"] lastObject];
                                 
                                 [self fetchTreeWithURL:[NSURL URLWithString:commit[@"tree"][@"url"]] completionBlock:block];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [UIAlertView bbu_showAlertWithError:error];
                             }];
     
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.commitsURL = [NSURL URLWithString:[self dropShaFromURLString:dictionary[@"commits_url"]]];
        self.fullName = dictionary[@"full_name"];
        self.name = dictionary[@"name"];
        self.treesURL = [NSURL URLWithString:[self dropShaFromURLString:dictionary[@"trees_url"]]];
        
        NSDictionary* owner = dictionary[@"owner"];
        self.avatarURL = [NSURL URLWithString:owner[@"avatar_url"]];
    }
    return self;
}

#pragma mark -

-(NSString *)canonicalName {
    return self.fullName;
}

-(Class)nodeClass {
    return [BBUGitHubTreeNode class];
}

@end
