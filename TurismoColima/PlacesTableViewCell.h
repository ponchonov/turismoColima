//
//  PlacesTableViewCell.h
//  üShopiOS
//
//  Created by Héctor Alfonso Cuevas Morfín on 11/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelNamePlace;
@property (weak, nonatomic) IBOutlet UIView *viewWithCorner;
@property (weak, nonatomic) IBOutlet UIView *viewWithTransparency;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
