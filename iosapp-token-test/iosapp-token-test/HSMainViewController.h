//
//  HSMainViewController.h
//  iosapp-token-test
//
//  Created by Vladimir Gnatiuk on 1/16/15.
//
//

#import <UIKit/UIKit.h>
#import "GTLYouTube.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface HSMainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain) GTLServiceYouTube *youtubeService;
@end
