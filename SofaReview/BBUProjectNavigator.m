//
//  BBUProjectNavigator.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGitHubRepo.h"
#import "BBUProjectNavigator.h"
#import "EXTScope.h"
#import "GHGitHubClient.h"
#import "GHGitHubUser.h"

@interface BBUProjectNavigator ()

@property (nonatomic, strong) GHGitHubClient* client;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSArray* repos;
@property (nonatomic, strong) GHGitHubUser* user;

@end

#pragma mark -

@implementation BBUProjectNavigator

- (RACSignal *)fetchUser {
	@unsafeify(self);
	return [[self.client
             fetchUserInfo]
            map:^(NSDictionary *userDict) {
                @strongify(self);
                
                [self.user setValuesForKeysWithDictionary:userDict];
                return [RACUnit defaultUnit];
            }];
}

- (RACSignal *)fetchRepos {
	return [[self.client
             fetchUserRepos]
            map:^(NSArray *repos) {
                //NSLog(@"repos: %@", repos);
                
                NSMutableArray* mRepos = [NSMutableArray new];
                
                for (NSDictionary* repoDict in repos) {
                    [mRepos addObject:[[BBUGitHubRepo alloc] initWithDictionary:repoDict]];
                }
                
                self.repos = mRepos;
                
                return [RACUnit defaultUnit];
            }];
}

- (RACSignal *)fetchOrgs {
	return [[self.client
             fetchUserOrgs]
            map:^(NSArray *orgs) {
                //NSLog(@"orgs: %@", orgs);
                return [RACUnit defaultUnit];
            }];
}

-(id)init {
    self = [super init];
    if (self) {
        self.loading = YES;
        self.user = [GHGitHubUser userWithUsername:@"user" password:@"password"];
        self.client = [GHGitHubClient clientForUser:self.user];
        
        @unsafeify(self);
        
        [[[RACSignal
           merge:[NSArray arrayWithObjects:[self fetchUser], [self fetchRepos], [self fetchOrgs], nil]]
          finally:^{
              @strongify(self);
              self.loading = NO;
          }]
         subscribeNext:^(id x) {
             // nothing
         } error:^(NSError *error) {
             @strongify(self);
             self.loading = NO;
             
             [UIAlertView bbu_showAlertWithError:error];
         } completed:^{
             //NSLog(@"done");
         }];
    }
    return self;
}

@end
