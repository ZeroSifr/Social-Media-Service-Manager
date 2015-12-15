//
//  ViewController.m
//  Social Media Service Manager
//
//  Created by Usman Khan on 04/10/2015.
//  Copyright © 2015 Usman Khan. All rights reserved.
//

#import "ViewController.h"
#import "UKSocialMediaServiceManager.h"

@interface ViewController ()

@property (nonatomic, strong) UKSocialMediaServiceManager *socialMediaServiceManager;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation ViewController

#pragma mark - Private

- (UIAlertController *)alertController {
    
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil
                                                               message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        
        [_alertController addAction:okAction];
        
    }
    
    return _alertController;
}

- (UKSocialMediaServiceManager *)socialMediaServiceManager{
    if (!_socialMediaServiceManager) {
        _socialMediaServiceManager = [[UKSocialMediaServiceManager alloc] init];
        [_socialMediaServiceManager setDelegate:self];
    }
    return _socialMediaServiceManager;
}

- (IBAction)didTapTwitterButton:(UIButton *)button {
    [[self socialMediaServiceManager] authenticateForSocialMediaType:Twitter];
}

- (IBAction)didTapFacebookButton:(UIButton *)button {
    [[self socialMediaServiceManager] authenticateForSocialMediaType:Facebook];
}

- (void)presentAlertViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:[self alertController] animated:YES completion:nil];
    });
}

#pragma mark - Social Media Service Manager Delegate

- (void)didAllowAccessToSocialMediaType:(SocialMediaType)socialMediaType withError:(NSError *)error {
    
    if (error) {
        [[self alertController] setMessage:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
        [self presentAlertViewController];
    } else {
        [[self socialMediaServiceManager] showSLComposeViewControllerWithTweet:@"Test Tweet from Social Media Class" andImage:nil];
    }
}

- (void)accountNotFoundForSocialMediaType:(SocialMediaType)socialMediaType withErrorMessage:(NSString *)errorMessage {
    [[self alertController] setMessage:errorMessage];
    [self presentAlertViewController];
}

- (void)SLComposeViewControllerPresented:(SLComposeViewController *)composeViewController {
    [self presentViewController:composeViewController animated:YES completion:nil];
}

@end
