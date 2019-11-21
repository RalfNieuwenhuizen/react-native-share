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

    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.composeVC = [[MFMessageComposeViewController alloc] init];
        self.composeVC.messageComposeDelegate = self;
         
        if ([options objectForKey:@"message"] && [options objectForKey:@"message"] != [NSNull null]) {
            // Configure the fields of the interface.
            NSString *text = [RCTConvert NSString:options[@"message"]];
            if ([options objectForKey:@"url"] && [options objectForKey:@"url"] != [NSNull null]) {
                text = [text stringByAppendingString: [@" " stringByAppendingString: [RCTConvert NSString:options[@"url"]]] ];
            }
            self.composeVC.body = text;
        }
         
        // Present the view controller modally.
        UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [ctrl presentViewController:self.composeVC animated:YES completion:nil];

        successCallback(@[]);
    });
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
              didFinishWithResult:(MessageComposeResult)result {
    NSLog(@"messageComposeViewController didFinishWithResult"); // TODO: This never seems to be called
    
    // Check the result or perform other tasks.
    // Dismiss the message compose view controller.
    [controller dismissViewControllerAnimated:YES completion:nil];

    // Different options here, dismiss from ctrl that presented it, or from controller itself
    // UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    // [ctrl dismissViewControllerAnimated:YES completion:nil];
}

@end
