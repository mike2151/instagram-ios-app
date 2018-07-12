//
//  ProfileViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/10/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "ProfileViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "ProfilePagePicCell.h"
#import "Post.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@end

@implementation ProfileViewController

-(void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    self.profilePic.file = user[@"ProfileImage"];
    [self.profilePic loadInBackground];
    self.userIdLabel.text = user[@"username"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.profilePic.layer.cornerRadius = 50;
    self.profilePic.layer.masksToBounds = YES;
    
    //get all the pictures for user
    [self getPictures];
    [self setUpCollectionView];
}

- (IBAction)onTapChangePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    //now update user
    PFUser *currUser = [PFUser currentUser];
    PFFile *profileFile = [PFFile fileWithName:@"photo.png" data:UIImagePNGRepresentation(editedImage)];
    currUser[@"ProfileImage"]= profileFile;
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.profilePic setImage:editedImage];
            [self.profilePic loadInBackground];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfilePagePicCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePagePicCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    cell.imagePreview.file = post[@"image"];
    [cell.imagePreview loadInBackground];
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    return cell;
}


-(void) setUpCollectionView {
    UICollectionViewFlowLayout *layout =  (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

-(void) getPictures {
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    //get picrtures only by user
    [query whereKey:@"userID" equalTo:currUser[@"username"]];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    DetailViewController *tweetViewController = [segue destinationViewController];
    tweetViewController.post = self.posts[indexPath.row];

}


@end
