//
//  DetailViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentViewController.h"
#import "CommentCell.h"
#import "ProfileViewController.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePioc;
@property (nonatomic) NSArray* comments;
@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated {
    [self setUpLikeButton];
    [self loadComments];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //convert email to user name
    self.authorLabel.text = [[self.post.userID componentsSeparatedByString:@"@"] objectAtIndex:0];
    self.profilePioc.file = self.post.author[@"ProfileImage"];
    [self.profilePioc loadInBackground];
    
    self.captionLabel.text = self.post.caption;
    
    [self setTimeStamp];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
}
- (IBAction)onTapLike:(id)sender {
    [self likePost];
}

-(void) setTimeStamp {
    //convert date to string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *result = [formatter stringFromDate:self.post.createdAt];
    self.timeStampLabel.text = result;
}

-(void) setUpLikeButton {
    int likeCountint = [self.post.likeCount intValue];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d%@", likeCountint, @" likes"] forState:UIControlStateNormal];
    UIImage *btnImage;
    if (likeCountint == 0) {
        btnImage = [UIImage imageNamed:@"empty_heart.png"];
    }
    else {
        btnImage = [UIImage imageNamed:@"filled_heart.png"];
    }
    [self.likeButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)likePost {
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

- (IBAction)onTapComment:(id)sender {
    [self performSegueWithIdentifier:@"detailToCommentSegue" sender:self];
}

-(void) loadComments {
    self.comments = self.post.comments;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.textLabel.text = self.comments[indexPath.row];
    return cell;
}

- (IBAction)onTapProfile:(id)sender {
    [self performSegueWithIdentifier:@"detailToProfileSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ProfileViewController class]]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
    }
    else {
        UINavigationController *navController = [segue destinationViewController];
        CommentViewController *commentViewController = navController.visibleViewController;
        commentViewController.post  = self.post;
    }
}


@end
