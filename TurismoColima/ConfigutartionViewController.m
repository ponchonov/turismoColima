//
//  ConfigutartionViewController.m
//  D4Travel
//
//  Created by Héctor Alfonso Cuevas Morfín on 17/12/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "ConfigutartionViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface ConfigutartionViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation ConfigutartionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.player loadWithVideoId:@"bVEDIcYuZKk"];
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            // Callback for login success or failure. The TWTRSession
            // is also available on the [Twitter sharedInstance]
            // singleton.
            //
            // Here we pop an alert just to give an example of how
            // to read Twitter user info out of a TWTRSession.
            //
            // TODO: Remove alert and use the TWTRSession's userID
            // with your app's user model
            NSString *message = [NSString stringWithFormat:@"@%@ logged in! (%@)",
                                 [session userName], [session userID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged in!"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
            
            [client loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
                if (tweet) {
                   // [self.tweetView configureWithTweet:tweet];
                    
                } else {
                    NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
                }
            }];
            [alert show];
        } else {
            NSLog(@"Login error: %@", [error localizedDescription]);
        }
    }];
    
    // TODO: Change where the log in button is positioned in your view
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
