//
//  InformationViewController.m
//  D4Travel
//
//  Created by Héctor Alfonso Cuevas Morfín on 25/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "InformationViewController.h"
#import "UIViewController+ECSlidingViewController.h"


@interface InformationViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Base this Tweet ID on some data from elsewhere in your app
   // TWTRAPIClient *client = [[TWTRAPIClient alloc]init];
   // self.dataSource = [[TWTRSearchTimelineDataSource alloc]initWithSearchQuery:@"redwoods" APIClient:client];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
            TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"@Turismo_Colima" APIClient:client];
            self.dataSource = userTimelineDataSource;
            NSLog(@"signed in as %@", [session userName]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Es necesario tener una cuenta de Twitter en ajuste para ver esta opción" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
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
