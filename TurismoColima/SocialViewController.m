//
//  SocialViewController.m
//  D4Travel
//
//  Created by Héctor Alfonso Cuevas Morfín on 22/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "SocialViewController.h"
#import "CJMTwitterFollowButton.h"
#import "UIViewController+ECSlidingViewController.h"
#import "InformationViewController.h"
#import "YTPlayerView.h"
//#import "FBSDKCoreKit.h"
//#import "FBSDKLoginKit.h"


@interface SocialViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (weak, nonatomic) IBOutlet CJMTwitterFollowButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewYoutube;
@property (nonatomic,strong) NSMutableArray *arrayWithItems;


@end

@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.delegate = self;
   
    _twitterButton.twitterAccount = @"Turismo_Colima";
    _arrayWithItems = [[NSMutableArray alloc]init];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InformationViewController *tvc=[storyboard instantiateViewControllerWithIdentifier:@"informationViewController"];
    [tvc.view setFrame:_firstView.frame];
    [self.firstView addSubview:tvc.view];
    [self addChildViewController:tvc];
    _tableViewYoutube.dataSource = self;
    _tableViewYoutube.delegate = self;
    /*
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
         }
     }];*/
        // Do any additional setup after loading the view.
    [self doUpdateMarkers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _arrayWithItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    
    NSMutableDictionary *dic = [_arrayWithItems objectAtIndex:indexPath.row];
    
   // NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[dic objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"] objectForKey:@"url"]]];
    NSData *data = [dic objectForKey:@"imgData"];
    cell.imageView.image = [UIImage imageWithData:data];
    YTPlayerView *viewYT = [[YTPlayerView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [viewYT loadWithVideoId:@"bVEDIcYuZKk"];
    [cell.contentView addSubview:viewYT];
    
    cell.textLabel.text = [[dic objectForKey:@"snippet"] objectForKey:@"title"];
    [cell.textLabel setNumberOfLines:0];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}

- (IBAction)facebookLike:(id)sender {
  
    NSURL *facebookURL = [NSURL URLWithString:@"fb://turicolima/?fref=ts"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/turicolima/?fref=ts"]];
    }
    
}
- (IBAction)youtubeButton:(id)sender {
    NSString *channelName = @"UCoID8WqVlBKyFPpLGgx_xdw";
    
    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://channel/%@",channelName]];
    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/channel/%@",channelName]];
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToAppURL];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWebURL];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrolled");
    NSLog(@"%f",scrollView.contentOffset.x);
    CGFloat point = scrollView.frame.size.width;
    if(scrollView == _scrollView)
    {
        if(scrollView.contentOffset.x >= point && scrollView.contentOffset.x <point*2)
        {
            [_segmentedControl setSelectedSegmentIndex:1];
        }
        else if(scrollView.contentOffset.x < point)
        {
            [_segmentedControl setSelectedSegmentIndex:0];
        }else
        {
            [_segmentedControl setSelectedSegmentIndex:2];
        }
    }
    
}
- (IBAction)segmentedChanged:(id)sender {
    
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }else if (_segmentedControl.selectedSegmentIndex == 1)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }else
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*2, 0)];
    }
}


-(void)doUpdateMarkers
{
    
        NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/search?key=AIzaSyCO-gxhdYD6aCdt5egR4qDkjXIj5Vyj3i8&channelId=UCoID8WqVlBKyFPpLGgx_xdw&part=snippet,id&order=date&maxResults=20"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(!error){
                NSError *JSONerror = nil;
                NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
                
                NSLog(@"%@", JSONDict);
               // _arrayWithItems = JSONDict[@"items"];
                
                for(NSDictionary *dic in JSONDict[@"items"])
                {
                    NSMutableDictionary *dicM = [dic mutableCopy];

                        
                       
                         NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[dicM objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"] objectForKey:@"url"]]];
                       // NSData *data = [NSData dataWithContentsOfURL:url];
                        [dicM setObject:data forKey:@"imgData"];
                    [_arrayWithItems addObject:dicM];
                    
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableViewYoutube reloadData];
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });        }
        }];
        
        [dataTask resume];
    
    
}


@end
