//
//  CardListTableViewCell.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardListTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lb_card_num;
@property (nonatomic, retain) IBOutlet UILabel *lb_card_name;

@property (nonatomic, copy) NSString *card_name;
@property (nonatomic, copy) NSString *card_num;

@end
