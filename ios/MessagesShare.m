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

    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;
     
    if ([options objectForKey:@"message"] && [options objectForKey:@"message"] != [NSNull null]) {
        // Configure the fields of the interface.
        NSString *text = [RCTConvert NSString:options[@"message"]];
        if ([options objectForKey:@"url"] && [options objectForKey:@"url"] != [NSNull null]) {
            text = [text stringByAppendingString: [@" " stringByAppendingString: [RCTConvert NSString:options[@"url"]]] ];
        }
        composeVC.body = text;
    }
     
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
