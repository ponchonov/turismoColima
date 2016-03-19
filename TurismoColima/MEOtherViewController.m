//
//  MEOtherViewController.m
//  üShopiOS
//
//  Created by HECTOR ALFONSO on 02/04/15.
//  Copyright (c) 2015 DEVTEAM. All rights reserved.
//

#import "MEOtherViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "PlacesTableViewCell.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "DetailPlaceViewController.h"
#define kSITIO_WEB "www.google.com"
#import "JGProgressHUD.h"
//#import <Parse/Parse.h>

@interface MEOtherViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPlaces;
@property ( nonatomic,strong) NSMutableArray *arrayOfPlaces;
@property (nonatomic, assign) NSInteger rowSelected;
@property (nonatomic,strong) NSMutableArray * arrayOfdictToPass;
@property (nonatomic,strong) JGProgressHUD *progressHUD;

@end

@implementation MEOtherViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewPlaces.dataSource = self;
    _tableViewPlaces.delegate = self;
    [_tableViewPlaces setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _arrayOfPlaces = [[NSMutableArray alloc]init];
    _arrayOfdictToPass= [[NSMutableArray alloc]init];
    _progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    _progressHUD.textLabel.text = @"Cargando...";
    
    [self doUpdateMarkers];
    

}
-(void)viewDidDisappear:(BOOL)animated
{
    if(_progressHUD.visible)
    {
        [_progressHUD dismissAnimated:YES];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self scrollViewDidScroll:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
    // MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
    //    if (!self.dynamicTransitionPanGesture) {
    //  self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
    //  }
    /*
     [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
     [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
     } else {*/
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    //}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _arrayOfPlaces.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 346.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    
    PlacesTableViewCell *cell = (PlacesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    PlacesTableViewCell *myCellView;
    static NSString *TableViewCellIdentifier = @"CountryCells";
    myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    myCellView = nil;
    if (myCellView == nil){
        myCellView = [[PlacesTableViewCell alloc]
                      initWithStyle:UITableViewCellStyleSubtitle
                      reuseIdentifier:TableViewCellIdentifier];
    }
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlacesTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
 
    }
   // cell.imageView.image = [UIImage imageNamed:@"image.png"];
  //  NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[_arrayOfPlaces objectAtIndex:indexPath.row]];
  //    NSURL *url = [NSURL URLWithString:stringURL];
  //  NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dic = [_arrayOfPlaces objectAtIndex:indexPath.row];
    //cell.imageViewPlace.contentMode = UIViewContentModeScaleToFill;
    cell.imageViewPlace.image =[UIImage imageWithData:[dic objectForKey:@"imageData"]];
    cell.labelNamePlace.text = [dic objectForKey:@"name"];
    cell.viewWithCorner.layer.cornerRadius = 8.0f;
    [cell.viewWithTransparency setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:.30f]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
    {  [_progressHUD showInView:self.view];
        
        
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
                       dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSMutableDictionary *dataSaved = [NSMutableDictionary new];
                        [_arrayOfdictToPass addObject:dic];
                        [dataSaved setObject:dic forKey:@"dictionary"];
                        [dataSaved setObject:[dic objectForKey:@"short_name"] forKey:@"name"];
                        [dataSaved setObject:[dic objectForKey:@"id_place"] forKey:@"id"];
                        [dataSaved setObject:[dic objectForKey:@"description"] forKey:@"descripcion"];
                        NSString *stringURL = [NSString stringWithFormat:@"http://54.200.40.169/d4travel/assets/uploads/files/%@",[dic objectForKey:@"image_url_large_1"]];
                        NSURL *url = [NSURL URLWithString:stringURL];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        [dataSaved setObject:data forKey:@"imageData"];
                        [_arrayOfPlaces addObject:dataSaved];
                
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [_tableViewPlaces reloadData];
                            if(_progressHUD.visible)
                            {
                                [_progressHUD dismissAnimated:YES];
                            }
                            
                        });
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    _rowSelected = indexPath.row;
    [self performSegueWithIdentifier:@"showPlaceDetail" sender:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableViewPlaces visibleCells];
    
    for (PlacesTableViewCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableViewPlaces didScrollOnView:self.view];
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailPlaceViewController *controller = [segue destinationViewController];
    NSDictionary *dic = [_arrayOfPlaces objectAtIndex:_rowSelected];
    NSString *data = [dic objectForKey:@"id"];
    controller.identifierPlace = data;
    controller.text = [dic objectForKey:@"descripcion"];
    //controller.dicToParse = [_arrayOfdictToPass objectAtIndex:_rowSelected];
    controller.dicToParse = [dic objectForKey:@"dictionary"];
    
}

/*
 CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake([[_dicToParse objectForKey:@"latitude"]floatValue],[[_dicToParse objectForKey:@"longitude"]floatValue]);
 MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
 MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
 item.name =  [_dicToParse objectForKey:@"name"];
 [item openInMapsWithLaunchOptions:nil];*/

@end
