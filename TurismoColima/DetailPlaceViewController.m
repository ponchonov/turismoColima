//
//  DetailPlaceViewController.m
//  D4Travel
//
//  Created by Héctor Alfonso Cuevas Morfín on 22/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "DetailPlaceViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <Mapbox/Mapbox.h>
#import <MapKit/MapKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "FSImageViewer.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"


#define kSITIO_WEB "www.google.com"

@interface DetailPlaceViewController ()<MGLMapViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *arrayForMenu;

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property ( nonatomic,strong) NSMutableArray *arrayOfPlaces;
@property (nonatomic,strong) NSMutableArray *arrayOfData;
@property (nonatomic,strong) NSMutableArray *arrayOfDataActivities;
@property (nonatomic,strong) NSMutableArray *arrayOfAmenities;
@property (nonatomic,strong) NSMutableArray *arrayOfActivities;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstSection;
@property (weak, nonatomic) IBOutlet UIImageView *secondSection;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *topActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstSeparatorActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondSeparatorActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mapViewActivityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation DetailPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [_topActivityIndicator startAnimating];
        [_firstSeparatorActivityIndicator startAnimating];
        [_secondSeparatorActivityIndicator startAnimating];
        [_mapViewActivityIndicator startAnimating];
    _costLabel.text = [_dicToParse objectForKey:@"cost"];
    _accessLabel.text = [_dicToParse objectForKey:@"access_type"];
     [_commentsLabel setTextAlignment:NSTextAlignmentJustified];
    _commentsLabel.text = [_dicToParse objectForKey:@"comments"];
   
    _topActivityIndicator.hidesWhenStopped = _firstSeparatorActivityIndicator.hidesWhenStopped = _secondSeparatorActivityIndicator.hidesWhenStopped = _mapViewActivityIndicator.hidesWhenStopped = YES;
    
    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _arrayOfPlaces = [[NSMutableArray alloc]init];
    _arrayForMenu = @[@"Información",@"Aménities",@"Cómo llegar",@"xxxxx"];
    self.mapView.delegate = self;
   
    _textViewDescription.text = _text;
    [_textViewDescription setTextAlignment:NSTextAlignmentJustified];
    _arrayOfData = [[NSMutableArray alloc]init];
    _arrayOfDataActivities = [[NSMutableArray alloc]init];
    _arrayOfAmenities = [[NSMutableArray alloc]init];
    _arrayOfActivities = [[NSMutableArray alloc]init];
    
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableViewActivities setSeparatorColor:[UIColor clearColor]];

    self.title = [_dicToParse objectForKey:@"name"];
    
    UITapGestureRecognizer *singleTapOwner = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(imageOwnerTapped:)];
    singleTapOwner.numberOfTapsRequired = 1;
    singleTapOwner.cancelsTouchesInView = YES;
    [_imageView setUserInteractionEnabled:YES];
    [_imageView addGestureRecognizer:singleTapOwner];
   

    
    UITapGestureRecognizer *topTaped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(topImageTaped:)];
    topTaped.numberOfTapsRequired = 1;
    topTaped.cancelsTouchesInView = YES;
    [_topImageView setUserInteractionEnabled:YES];
    [_topImageView addGestureRecognizer:topTaped];
    
    UITapGestureRecognizer *firsSectionTaped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(topImageTaped:)];
    firsSectionTaped.numberOfTapsRequired = 1;
    firsSectionTaped.cancelsTouchesInView = YES;
    [_firstSection setUserInteractionEnabled:YES];
    [_firstSection addGestureRecognizer:firsSectionTaped];
    
    UITapGestureRecognizer *secondSection = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(topImageTaped:)];
    secondSection.numberOfTapsRequired = 1;
    secondSection.cancelsTouchesInView = YES;
    [_secondSection setUserInteractionEnabled:YES];
    [_secondSection addGestureRecognizer:secondSection];
    
    _webView.scrollView.scrollEnabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([[_dicToParse objectForKey:@"latitude"]floatValue ], [[_dicToParse objectForKey:@"longitude"]floatValue ]);
    point.title = [_dicToParse objectForKey:@"name"];;
    //  point.subtitle = @"Welcome to The Ellipse.";
    
    // Add annotation `point` to the map
    [self.mapView addAnnotation:point];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([[_dicToParse objectForKey:@"latitude"]floatValue ], [[_dicToParse objectForKey:@"longitude"]floatValue ]);
    [self.mapView setCenterCoordinate:centerCoordinate zoomLevel:13 animated:YES];
    
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *stringURL = [NSString stringWithFormat:@"https://api.mapbox.com/v4/mapbox.streets/pin-s-star+f83(%@,%@)/%@,%@,13/500x300@2x.png?access_token=pk.eyJ1IjoicG9uY2hvbm92IiwiYSI6ImNpZ3Zxa3ZoMDBydzl3Y201cGhrbnRpeDUifQ.Zt9aVX6OklIIz6QSjxvVDA",[_dicToParse objectForKey:@"longitude"], [_dicToParse objectForKey:@"latitude"],[_dicToParse objectForKey:@"longitude"], [_dicToParse objectForKey:@"latitude"]];
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async( dispatch_get_main_queue(), ^{
            [_mapViewActivityIndicator stopAnimating];
            _imageView.image = [UIImage imageWithData:data];
                    });
        
        [self doUpdateMarkers];
        if([_dicToParse objectForKey:@"image_url_large_1"])
        {
            
            NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:@"image_url_large_1"]];
            NSURL *url = [NSURL URLWithString:stringURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            _topImageView.contentMode = UIViewContentModeScaleAspectFill;
           
            dispatch_async( dispatch_get_main_queue(), ^{
                [_topActivityIndicator stopAnimating];
                 _topImageView.image = [UIImage imageWithData:data];
                
            });
        }
        if([_dicToParse objectForKey:@"image_url_large_2"])
        {
            NSString *stringURL2 = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:@"image_url_large_2"]];
            NSURL *url2 = [NSURL URLWithString:stringURL2];
            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            [_arrayOfData addObject:data2];
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [_firstSeparatorActivityIndicator stopAnimating];
               
                _firstSection.contentMode = UIViewContentModeScaleToFill;
                _firstSection.image = [UIImage imageWithData:data2];
            });
        }
        if([_dicToParse objectForKey:@"image_url_large_3"])
        {
            NSString *stringURL3 = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:@"image_url_large_3"]];
            NSURL *url3 = [NSURL URLWithString:stringURL3];
            NSData *data3 = [NSData dataWithContentsOfURL:url3];
            [_arrayOfData addObject:data3];
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                _secondSection.contentMode = UIViewContentModeScaleToFill;
                [_secondSeparatorActivityIndicator stopAnimating];
                _secondSection.image = [UIImage imageWithData:data3];
            });
            
        }
        if([_dicToParse objectForKey:@"image_url_large_4"])
        {
            NSString *stringURL4 = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:@"image_url_large_4"]];
            NSURL *url4 = [NSURL URLWithString:stringURL4];
            NSData *data4 = [NSData dataWithContentsOfURL:url4];
            [_arrayOfData addObject:data4];
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        if([_dicToParse objectForKey:@"image_url_large_5"])
        {
            NSString *stringURL5 = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:@"image_url_large_5"]];
            NSURL *url5 = [NSURL URLWithString:stringURL5];
            NSData *data5 = [NSData dataWithContentsOfURL:url5];
            if(data5 !=nil)
                [_arrayOfData addObject:data5];
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }
        

        
    });
    
    NSString *videoID = [_dicToParse objectForKey:@"video"];
    NSArray *idSplited = [videoID componentsSeparatedByString:@"v="];
    NSString *embedHTML = @"<html><body><iframe width=\"%0.0f\" height=\"315\" src=\"https://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML,_webView.frame.size.width ,[idSplited objectAtIndex:1]];
    
    //  UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [_webView loadHTMLString:html baseURL:nil];
    
}

#pragma mark CollectionView delegates
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
   
    if(_arrayOfData.count >0)
    {
        return _arrayOfData.count;
    }
    else
        return 2;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    
    if(!_arrayOfData.count == 0)
    {
        imageView.image =[UIImage imageWithData:[_arrayOfData objectAtIndex:indexPath.row]];
   
    }
    //    imageView.image = [UIImage imageNamed:@"image.png"];
    return cell;
}

#pragma TableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableViewActivities)
        return _arrayOfActivities.count;
    return _arrayOfAmenities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
   // UIImageView *imageView = (UIImageView *)[myCell viewWithTag:101];
    //imageView.image = [UIImage imageWithData:[_arrayOfAmenities objectAtIndex:indexPath.row]];
    NSMutableDictionary *dict;

    
    dict = [_arrayOfAmenities objectAtIndex:indexPath.row];
    if(tableView == _tableViewActivities)
        dict = [_arrayOfActivities objectAtIndex:indexPath.row];
    
    myCell.imageView.image = [UIImage imageWithData:[dict objectForKey:@"img_data"]];
    myCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    myCell.textLabel.text = [dict objectForKey:@"nombre"];
    [myCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return myCell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)doUpdateMarkers
{
    if([self conexion])
    {
        
        NSString *string = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/index.php/api/places/%@",_identifierPlace];
        NSURL *url = [NSURL URLWithString:string];
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
                
                
                for(NSDictionary *dic in JSONDict[@"amenities"])
                {
                    NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[dic objectForKey:@"image_url_thumb"]];
                    NSURL *url = [NSURL URLWithString:stringURL];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:data forKey:@"img_data"];
                    [dict setObject:[dic objectForKey:@"name" ] forKey:@"nombre"];
                    [_arrayOfAmenities addObject:dict];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                    });
                }
                
                for(NSDictionary *dic in JSONDict[@"activities"])
                {
                    NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[dic objectForKey:@"image_url_thumb"]];
                    NSURL *url = [NSURL URLWithString:stringURL];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:data forKey:@"img_data"];
                    [dict setObject:[dic objectForKey:@"name" ] forKey:@"nombre"];
                    [_arrayOfActivities addObject:dict];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableViewActivities reloadData];
                    });
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
            }
        }];
        
        [dataTask resume];
    }
    
}
-(void)imageOwnerTapped:id
{
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake([[_dicToParse objectForKey:@"latitude"]floatValue],[[_dicToParse objectForKey:@"longitude"]floatValue]);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name =  [_dicToParse objectForKey:@"name"];
    [item openInMapsWithLaunchOptions:nil];
}

-(void)topImageTaped:id
{
    static NSString* pieceOfString = @"image_url_large_";
    BOOL status = YES;
    int number = 1;
    NSMutableArray *arrayWithFSBasicImages = [[NSMutableArray alloc]init];
    while(status)
    {
        if([_dicToParse objectForKey:[NSString stringWithFormat:@"%@%d",pieceOfString,number]])
        {
            NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_dicToParse objectForKey:[NSString stringWithFormat:@"%@%d",pieceOfString,number]]];
            NSURL *url = [NSURL URLWithString:stringURL];
             FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:url name:[_dicToParse objectForKey:@"name"]];
            [arrayWithFSBasicImages addObject:firstPhoto];
            number++;
            
        }
        else
        {
            status = NO;
        }
    }
   

    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:arrayWithFSBasicImages];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    [imageViewController setSharingDisabled:YES];
    [imageViewController setRotationEnabled:YES];
    [self.navigationController pushViewController:imageViewController animated:YES];
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

@end
