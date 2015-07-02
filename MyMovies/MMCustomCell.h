//
//  HWCustomCell.h
//  Phonebook_HomeWork
//
//  Created by Mary on 5/21/14.
//  Copyright (c) 2014 Mary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingimageView;


@end
