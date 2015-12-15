//
//  UKSocialMediaServiceManager.m
//  Social Media Service Manager
//
//  Created by Usman Khan on 04/10/2015.
//  Copyright © 2015 Usman Khan. All rights reserved.
//

#import "UKSocialMediaServiceManager.h"
#import <Accounts/Accounts.h>

@interface UKSocialMediaServiceManager ()

@property (nonatomic, strong) NSDictionary *accountsErrorMessages;
@property (nonatomic) BOOL twitterAuthenticationGranted;

@end

@implementation UKSocialMediaServiceManager

#pragma mark - Public

- (void)authenticateForSocialMediaType:(SocialMediaType)socialMedia {
    switch (socialMedia) {
        case 0:
            [self UKPRI_authenticateTwitter];
            break;
        case 1:
            [self UKPRI_authenticateFacebook];
            break;
        default:
            break;
    }
}

- (void)showSLComposeViewControllerWithTweet:(NSString *)tweet andImage:(UIImage *)image {
    
    if ([self twitterAuthenticationGranted]) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if ([tweet length] > 0) {
            [composeViewController setInitialText:tweet];
        }
        
        if (image) {
            [composeViewController addImage:image];
        }
        
        if ([[self delegate] respondsToSelector:@selector(SLComposeViewControllerPresented:)]) {
            [[self delegate] SLComposeViewControllerPresented:composeViewController];
        }
        
    } else {
        [self UKPRI_authenticateTwitter];
    }
}

#pragma mark - Private

- (NSDictionary *)accountsErrorMessages {
    
    if (!_accountsErrorMessages) {
        _accountsErrorMessages = @{@(Twitter) : @"No Twitter account found.",
                                   @(Facebook) : @"No Facebook account found."};
    }
    
    return _accountsErrorMessages;
}

- (void)UKPRI_authenticateFacebook {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:@{ACFacebookAppIdKey:@"205213729813541",
                                                    ACFacebookPermissionsKey: @[@"email"],
                                                    ACFacebookAudienceKey: ACFacebookAudienceFriends,
                                                    }
     
                                       completion:^(BOOL granted, NSError *error) {
                                           
       if (granted) {
           NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
           if ([accounts count] > 0) {
               if ([[self delegate] respondsToSelector:@selector(didAllowAccessToSocialMediaType:withError:)]) {
                   [[self delegate] didAllowAccessToSocialMediaType:Twitter withError:error];
               }
           }
       } else {
                [[self delegate] accountNotFoundForSocialMediaType:Twitter
                                                  withErrorMessage:[[self accountsErrorMessages] objectForKey:@(Facebook)]];
       }
    }];
}
- (void)UKPRI_authenticateTwitter {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType
                                                 options:nil
                                              completion:^(BOOL granted, NSError *error) {
                                                
      [self setTwitterAuthenticationGranted:granted];
      
      if (granted) {
          NSArray *accounts = [accountStore accountsWithAccountType:twitterAccountType];
         
          if ([accounts count] > 0) {
              if ([[self delegate] respondsToSelector:@selector(didAllowAccessToSocialMediaType:withError:)]) {
                  [[self delegate] didAllowAccessToSocialMediaType:Twitter withError:error];
              }
          } else
          {
              if ([[self delegate] respondsToSelector:@selector(accountNotFoundForSocialMediaType:withErrorMessage:)]) {
                  [[self delegate] accountNotFoundForSocialMediaType:Twitter withErrorMessage:[[self accountsErrorMessages] objectForKey:@(Twitter)]];
              }
          }
      } else {
          if ([[self delegate] respondsToSelector:@selector(didAllowAccessToSocialMediaType:withError:)]) {
              [[self delegate] didAllowAccessToSocialMediaType:Twitter withError:error];
          }
      }
    }];
}

@end
