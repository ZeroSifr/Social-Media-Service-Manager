//
//  UKSocialMediaServiceManager.h
//  Social Media Service Manager
//
//  Created by Usman Khan on 04/10/2015.
//  Copyright © 2015 Usman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Social/Social.h>

 typedef enum : NSUInteger {
    Twitter,
    Facebook,
    GooglePlus,
}SocialMediaType;

@protocol SocialMediaServiceManagerDelegate;

@interface UKSocialMediaServiceManager : NSObject

@property (nonatomic, weak) id<SocialMediaServiceManagerDelegate> delegate;

/*
 @params SocialMediaType - Twitter, Facebook, GooglePlus
 
 Begins authentication process for the passed in social media type.
 
 Twitter/Facebook - Checks if the user has a Twitter or Facebook account setup 
 on their device.
 
 GooglePlus - The user is taken to a safari to authenticate via Google Plus
 
*/

- (void)authenticateForSocialMediaType:(SocialMediaType)socialMediaType;

- (void)showSLComposeViewControllerWithTweet:(NSString *)tweet andImage:(UIImage *)image;

@end

@protocol SocialMediaServiceManagerDelegate <NSObject>

- (void)didAllowAccessToSocialMediaType:(SocialMediaType)socialMediaType withError:(NSError *)error;
- (void)accountNotFoundForSocialMediaType:(SocialMediaType)socialMediaType withErrorMessage:(NSString *)errorMessage;
- (void)SLComposeViewControllerPresented:(SLComposeViewController *)composeViewController;

@end