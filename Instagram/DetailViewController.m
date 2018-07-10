//
//  DetailViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //convert email to user name
    self.authorLabel.text = [[self.post.userID componentsSeparatedByString:@"@"] objectAtIndex:0];
    self.captionLabel.text = self.post.caption;
    self.numLikesLabel.text = [NSString stringWithFormat:@"%d%@", [self.post.likeCount intValue], @" likes"];
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
}



@end
