//
//  BBUGitHubRepo.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGitHubTreeOwner.h"

@interface BBUGitHubRepo : BBUGitHubTreeOwner

-(NSURL*)avatarURL;
-(NSString*)name;
-(NSURL*)treesURL;

@end
