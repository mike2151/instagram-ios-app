//
//  CommentViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/10/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentText;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)onTapClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTapComment:(id)sender {
    NSString* comment = self.commentText.text;
    //current comments
    NSMutableArray* currComments =[NSMutableArray arrayWithArray:self.post.comments];
    [currComments addObject:comment];
    //save with comments
    NSArray *arrayComments = [currComments copy];
    self.post.comments = arrayComments;
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

@end
