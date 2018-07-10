//
//  CaptureViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "CaptureViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "MBProgressHUD.h"


@interface CaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextView *imageCaption;

@end

@implementation CaptureViewController

- (void) makeAlertController: (NSString *) title message:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadPreviewIfPossible];
}

- (IBAction)onTapTakePic:(id)sender {
    [self performSegueWithIdentifier:@"toCameraSegue" sender:nil];
    [self loadPreviewIfPossible];

}

- (IBAction)onTapUploadCameraRole:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void) loadPreviewIfPossible {
    if (self.imageToPost != nil) {
        [self.imagePreview setImage:self.imageToPost];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [self.imagePreview setImage:editedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onTapPost:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //get the image from the image view
    UIImage *imageToPost = [self.imagePreview image];
    if (imageToPost == nil) {
        [self makeAlertController:@"No Image Selected" message:@"Please capture or select an image"];
    }
    else {
        PFUser *user = [PFUser currentUser];
        Post *post = [Post new];
        post.postID = [self randomStringWithLength:16];
        post.userID = user.username;
        post.likeCount = 0;
        post.commentCount = 0;
        PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:UIImagePNGRepresentation(imageToPost)]; 
        post.image= imageFile;
        post.caption = self.imageCaption.text;
        post.author = user;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //go to timeline
                [self.tabBarController setSelectedIndex:0];
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}




//used for generating post Ids
//adopted from https://stackoverflow.com/a/2633948
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}


- (IBAction)onTapGesture:(id)sender {
    [self.imageCaption resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
