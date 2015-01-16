//
//  HSMainViewController.m
//  iosapp-token-test
//
//  Created by Vladimir Gnatiuk on 1/16/15.
//
//

#import "HSMainViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "Utils.h"
#import "VideoUploadViewController.h"

@interface HSMainViewController ()

@end

@implementation HSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.youtubeService = [[GTLServiceYouTube alloc] init];
	self.youtubeService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
														  clientID:kClientID
													  clientSecret:kClientSecret];
	if (![self isAuthorized]) {
		// Not yet authorized, request authorization and push the login UI onto the navigation stack.
		[[self navigationController] pushViewController:[self createAuthController] animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// Helper to check if user is authorized
- (BOOL)isAuthorized {
	return [((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to YouTube.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
	GTMOAuth2ViewControllerTouch *authController;
	
	authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
																clientID:kClientID
															clientSecret:kClientSecret
														keychainItemName:kKeychainItemName
																delegate:self
														finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	return authController;
}

// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
	if (error != nil) {
		[Utils showAlert:@"Authentication Error" message:error.localizedDescription];
		self.youtubeService.authorizer = nil;
	} else {
		self.youtubeService.authorizer = authResult;
	}
}

- (IBAction)startOAuthFlow:(id)sender
{
	GTMOAuth2ViewControllerTouch *viewController;
	
	viewController = [[GTMOAuth2ViewControllerTouch alloc]
					  initWithScope:kGTLAuthScopeYouTube
					  clientID:kClientID
					  clientSecret:kClientSecret
					  keychainItemName:kKeychainItemName
					  delegate:self
					  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (IBAction)showCamera:(id)sender
{
	UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else {
		// In case we're running the iPhone simulator, fall back on the photo library instead.
		cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			[Utils showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
			return;
		}
	}
	cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
	cameraUI.allowsEditing = YES;
	cameraUI.delegate = self;
	[self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
	
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if (CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		
		NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
		
		VideoUploadViewController *uploadController = [[VideoUploadViewController alloc] init];
		uploadController.videoUrl = videoUrl;
		uploadController.youtubeService = self.youtubeService;
		
		[[self navigationController] pushViewController:uploadController animated:YES];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
