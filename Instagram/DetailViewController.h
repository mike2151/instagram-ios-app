//
//  DetailViewController.h
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Post* post;
@end
