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
            NSLog(@"success");
            [self.likeButton setTitle:[NSString stringWithFormat:@"%@%@", self.post.likeCount, @"   likes"] forState:UIControlStateNormal];
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

@end
