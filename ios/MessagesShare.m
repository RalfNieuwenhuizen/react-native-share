//
//  MessagesShare.m
//  RNShare
//
//  Created by Ralf Nieuwenhuizen on 19-11-19.
//

#import "MessagesShare.h"
#import <MessageUI/MFMessageComposeViewController.h>

@implementation MessagesShare
- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {
    
    NSLog(@"Try open view");
    
    if (![MFMessageComposeViewController canSendText]) {
       NSLog(@"Message services are not available.");
    }

//    [[CTMessageCenter sharedMessageCenter] sendSMSWithText: serviceCenter:nil toAddress:nil];
    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;
     
    // Configure the fields of the interface.
    composeVC.recipients = @[@"14085551212"];
    composeVC.body = options[@"url"];
     
    // Present the view controller modally.
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:composeVC animated:YES completion:nil];
    
    successCallback(@[]);
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
              didFinishWithResult:(MessageComposeResult)result {
    // Check the result or perform other tasks.
    // Dismiss the message compose view controller.
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}

@end
