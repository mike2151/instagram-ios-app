//
//  HomePageViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "HomePageViewController.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import <ParseUI/ParseUI.h>
#import "DetailViewController.h"
#import "CommentViewController.h"

@interface HomePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int tappedReplyButtonIndex;

@end

@implementation HomePageViewController

-(void)viewDidAppear:(BOOL)animated {
    self.tappedReplyButtonIndex = -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self loadTimeLine];
}

- (void) loadTimeLine {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)onTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //go back to login
        [self performSegueWithIdentifier:@"backToLoginSegue" sender:nil];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    PFObject *post = self.posts[indexPath.row];
    cell.post = self.posts[indexPath.row];
    cell.captionLabel.text = post[@"caption"];
    int likeCountint = [cell.post.likeCount intValue];
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%d%@", likeCountint, @"   likes"] forState:UIControlStateNormal];
    UIImage *btnImage;
    if (likeCountint == 0) {
        btnImage = [UIImage imageNamed:@"empty_heart.png"];
    }
    else {
        btnImage = [UIImage imageNamed:@"filled_heart.png"];
    }
    [cell.likeButton setImage:btnImage forState:UIControlStateNormal];
    cell.postImageView.file = post[@"image"];
    cell.commentButton.tag = indexPath.row;
    [cell.postImageView loadInBackground];
    cell.authorName.text = [[post[@"author"][@"username"] componentsSeparatedByString:@"@"] objectAtIndex:0];
    cell.profilePic.file = post[@"author"][@"ProfileImage"];
    [cell.profilePic loadInBackground];

    return cell;
}


- (IBAction)onTapComment:(UIButton *)sender {
    self.tappedReplyButtonIndex = (int) sender.tag;
    [self performSegueWithIdentifier:@"toCommentSegue" sender:self];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self loadTimeLine];
    [refreshControl endRefreshing];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = self.posts[indexPath.row];
    }
    else {
        if (self.tappedReplyButtonIndex != -1) {
            UINavigationController *navController = [segue destinationViewController];
            CommentViewController *commentViewController = navController.visibleViewController;
            commentViewController.post  = self.posts[self.tappedReplyButtonIndex];
            self.tappedReplyButtonIndex = -1;
        }
    }
}


@end
