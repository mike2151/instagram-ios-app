//
//  PostCell.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTapLike:(id)sender {
    int likeCountint =[self.post.likeCount intValue];
    if (likeCountint == 0) {
        likeCountint = 1;
    }
    else {
        likeCountint = 0;
    }
    self.post.likeCount = [NSNumber numberWithInt:likeCountint];
    //now update
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.likeButton setTitle:[NSString stringWithFormat:@"%@%d%@", @"    ",likeCountint, @" likes"] forState:UIControlStateNormal];
            UIImage *btnImage;
            if (likeCountint == 0) {
                btnImage = [UIImage imageNamed:@"empty_heart.png"];
            }
            else {
                btnImage = [UIImage imageNamed:@"filled_heart.png"];
            }
            [self.likeButton setImage:btnImage forState:UIControlStateNormal];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(void) setCellInfo {
    self.captionLabel.text = self.post[@"caption"];
    int likeCountint = [self.post.likeCount intValue];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@%d%@", @"    ",likeCountint, @" likes"] forState:UIControlStateNormal];
    UIImage *btnImage;
    if (likeCountint == 0) {
        btnImage = [UIImage imageNamed:@"empty_heart.png"];
    }
    else {
        btnImage = [UIImage imageNamed:@"filled_heart.png"];
    }
    [self.likeButton setImage:btnImage forState:UIControlStateNormal];
    [self setTimeStamp];
    
    self.profilePic.layer.cornerRadius = 25;
    self.profilePic.layer.masksToBounds = YES;
    self.postImageView.file = self.post[@"image"];
    
    [self.postImageView loadInBackground];
    self.authorName.text = [[self.post[@"author"][@"username"] componentsSeparatedByString:@"@"] objectAtIndex:0];
    self.profilePic.file = self.post[@"author"][@"ProfileImage"];
    [self.profilePic loadInBackground];
}

-(void) setTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *result = [formatter stringFromDate:self.post.createdAt];
    self.timePostedLabel.text = result;
}


@end
