//
//  PlacesTableViewCell.m
//  üShopiOS
//
//  Created by Héctor Alfonso Cuevas Morfín on 11/11/15.
//  Copyright © 2015 DEVTEAM. All rights reserved.
//

#import "PlacesTableViewCell.h"

@implementation PlacesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.imageViewPlace.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.imageViewPlace.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.imageViewPlace.frame = imageRect;
}


@end
