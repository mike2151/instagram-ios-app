//
//  CommentViewController.h
//  Instagram
//
//  Created by Michael Abelar on 7/10/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface CommentViewController : UIViewController
@property (nonatomic) Post* post;
@end
