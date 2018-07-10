//
//  Post.h
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "PFObject.h"
#import "Parse/Parse.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

@end
