//
//  Post.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "Post.h"

@implementation Post
    @dynamic postID;
    @dynamic userID;
    @dynamic description;
    @dynamic image;

    + (nonnull NSString *)parseClassName {
        return @"Post";
    }
@end
