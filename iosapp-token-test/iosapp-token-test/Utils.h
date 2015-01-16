//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DEFAULT_KEYWORD = @"ytdl";
static NSString *const UPLOAD_PLAYLIST = @"test_playlist";

static NSString *const kClientID = @"453667159707-rttvli5a8pko643ip3nipc0b7ne6s87v.apps.googleusercontent.com";
static NSString *const kClientSecret = @"5ZmnqSh566ot5CeKq-z4KTir";

static NSString *const kKeychainItemName = @"YouTube Direct Lite";

@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat;

@end
