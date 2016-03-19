//
//  DetailPlaceViewController.h
//  D4Travel
//
//  Created by Héctor Alfonso Cuevas Morfín on 22/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPlaceViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewActivities;

@property (nonatomic, strong) NSString *identifierPlace;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSDictionary *dicToParse;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;



@end
