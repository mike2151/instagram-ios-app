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

@interface HomePageViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int tappedReplyButtonIndex;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic) int numPostsToGet;
//so we know which posts we already loaded
@property (nonatomic) NSMutableArray* postIds;

@end

@implementation HomePageViewController


-(void)viewDidAppear:(BOOL)animated {
    self.tappedReplyButtonIndex = -1;
    self.numPostsToGet = 20;
    self.postIds = [[NSMutableArray alloc] init];
    [self loadTimeLine];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTimeLineitlec) name:@"timelineNeedsUpdate" object:nil];
}

- (void) loadTimeLine {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            if ([self.posts count] != [posts count]) {
                self.posts = posts;
                for (Post* post in posts) {
                    [self.postIds addObject:post.postID];
                }
                [self.tableView reloadData];
            }
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
    cell.post = self.posts[indexPath.row];
    [cell setCellInfo];
    cell.commentButton.tag = indexPath.row;
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

-(void)loadMoreData{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = self.numPostsToGet;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            //temp array
            NSMutableArray* newPosts = [NSMutableArray arrayWithArray:self.posts];
            for (Post* post in posts) {
                if (!([self.postIds containsObject:post.postID])) {
                    [newPosts addObject:post.postID];
                    [self.postIds addObject:post.postID];
                }
            }
            if ([self.posts count] != [newPosts count]) {
                self.posts = [newPosts copy];
                self.numPostsToGet = self.numPostsToGet + 20;
                self.isMoreDataLoading = false;
                [self.tableView reloadData];
            }
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
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
