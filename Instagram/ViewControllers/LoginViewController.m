//
//  LoginViewController.m
//  Instagram
//
//  Created by Michael Abelar on 7/9/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController
- (IBAction)onTapSignup:(id)sender {
    [self registerUser];
}

- (IBAction)onTapLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error == nil) {
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        }
    }];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.emailField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error == nil) {
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        }
    }];
}

- (IBAction)onTapGesture:(id)sender {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
