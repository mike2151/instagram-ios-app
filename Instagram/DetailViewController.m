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
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //convert email to user name
    self.authorLabel.text = [[self.post.userID componentsSeparatedByString:@"@"] objectAtIndex:0];
    self.captionLabel.text = self.post.caption;
    self.numLikesLabel.text = [NSString stringWithFormat:@"%d%@", [self.post.likeCount intValue], @" likes"];
    self.postImage.file = self.post.image;
    //convert date to string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *result = [formatter stringFromDate:self.post.createdAt];
    self.timeStampLabel.text = result;
    [self.postImage loadInBackground];
}



@end
