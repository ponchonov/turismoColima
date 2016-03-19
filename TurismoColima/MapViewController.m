//
//  MapViewController.m
//  üShopiOS
//
//  Created by Héctor Alfonso Cuevas Morfín on 11/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "MapViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <Mapbox/Mapbox.h>


#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface MapViewController ()<MGLMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (weak, nonatomic) IBOutlet UILabel *titleInfoView;
@property ( nonatomic,strong) NSMutableDictionary *arrayWithInfo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *placeImage;
@property (weak, nonatomic) IBOutlet UITextView *textViewInfo;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MGLUserTrackingModeFollow;
     [_placeImage setContentMode:UIViewContentModeScaleToFill];
    _arrayWithInfo = [[NSMutableDictionary alloc]init];
   /* [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(19.123, -103.1)
                       zoomLevel:20
                        animated:YES];
    **/
    [_informationView setHidden:YES];
    _informationView.layer.cornerRadius = 8.0;
    
    [self doUpdateMarkers];
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(, [[_dicToParse objectForKey:@"longitude"]floatValue ]);
    //[self.mapView setCenterCoordinate:centerCoordinate zoomLevel:13 animated:YES];
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.mapView clearsContextBeforeDrawing];
    [self doUpdateMarkers];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    
    return nil;
}
-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation
{
  [_activityIndicator setHidden:NO];
  
    //[_activityIndicator setHidesWhenStopped:YES];
    MGLPointAnnotation *anotation = annotation;
    
      NSLog(@"Anotation callout %@",anotation.title);
    _placeImage.image = [UIImage imageNamed:@"logo"];
    NSMutableDictionary *dic = [_arrayWithInfo objectForKey:anotation.title];
    _titleInfoView.text = [dic objectForKey:@"name"];
    _textViewInfo.text = [dic objectForKey:@"description"];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[dic objectForKey:@"image_url_large_1"]];
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
       
        dispatch_async( dispatch_get_main_queue(), ^{
            _placeImage.image = [UIImage imageWithData:data];
            [_activityIndicator setHidden:YES];
        });
    });
    
    [_informationView setHidden:NO];
    
    
    
}

// Allow markers callouts to show when tapped
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}


- (BOOL)conexion{
    SCNetworkReachabilityRef referencia = SCNetworkReachabilityCreateWithName (kCFAllocatorDefault, kSITIO_WEB);
    
    SCNetworkReachabilityFlags resultado;
    SCNetworkReachabilityGetFlags ( referencia, &resultado );
    
    CFRelease(referencia);
    
    if (resultado & kSCNetworkReachabilityFlagsReachable) {
        return YES;
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Conectividad"
                                                        message:@"No tienes conexión a internet "
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    
}

-(void)doUpdateMarkers
{
    if([self conexion])
    {
        
        
        NSURL *url = [NSURL URLWithString:@"http://54.200.40.169/d4travel/index.php/api/places"];
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
                for(NSDictionary *dic in JSONDict)
                {
                   
                    [_arrayWithInfo setObject:dic forKey:[dic objectForKey:@"name"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                        point.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"]floatValue ], [[dic objectForKey:@"longitude"]floatValue ]);
                        point.title = [dic objectForKey:@"name"];;
                        point.subtitle = @"";
                        //  point.subtitle = @"Welcome to The Ellipse.";
                        
                        // Add annotation `point` to the map
                        [self.mapView addAnnotation:point];
                        
                    });
                }
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    
                });        }
        }];
        
        [dataTask resume];
    }
    
}
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (IBAction)closeButton:(id)sender {
    [_informationView setHidden:YES];
}

@end
