//
//  InstagramStoriesShare.m
//  RNShare
//
//  Created by Ralf Nieuwenhuizen on 22-10-19.
//

#import "InstagramStoriesShare.h"
#import <AVFoundation/AVFoundation.h>
#import "InstagramShare.h"

@implementation InstagramStoriesShare
- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {
    
    NSLog(@"Try open view");

    NSURL * fileURL = [NSURL URLWithString: options[@"url"]];
    AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    CMTime videoDuration = videoAsset.duration;
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);

    NSLog(@"Video duration: %f seconds for file %@", videoDurationSeconds, videoAsset.URL.absoluteString);
        
    NSURL * shareURL;
    // Instagram doesn't allow sharing videos longer than 20 seconds to stories
    // https://developers.facebook.com/docs/instagram/sharing-to-stories/
    if (videoDurationSeconds <= 20.0f) {
        shareURL = [NSURL URLWithString:@"instagram-stories://share"];
    } else {
        shareURL = [NSURL URLWithString:@"instagram://camera"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL: shareURL]) {
        // Assign background and sticker image assets and
        // attribution link URL to pasteboard
        NSError* fileDataError = nil;
        NSData* fileData = [NSData dataWithContentsOfFile:options[@"url"] options:0 error:&fileDataError];
        
        if (fileData == nil || fileDataError != nil) {
            failureCallback(fileDataError);
            return;
        }

        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundVideo" : fileData,
                                       @"com.instagram.sharedSticker.contentURL" : @"https://www.relive.cc",
                                       @"com.instagram.sharedSticker.backgroundTopColor" : @"#FFDD00",
                                       @"com.instagram.sharedSticker.backgroundBottomColor" : @"#FFDD00"}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        
        [[UIApplication sharedApplication] openURL: shareURL];
        successCallback(@[]);
    } else {
        NSLog(@"TRY OPEN instagram");
        InstagramShare *shareCtl = [[InstagramShare alloc] init];
        [shareCtl shareSingle:options failureCallback: failureCallback successCallback: successCallback];
    }
}

@end
