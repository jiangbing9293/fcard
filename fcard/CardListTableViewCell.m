//
//  CardListTableViewCell.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "CardListTableViewCell.h"

@implementation CardListTableViewCell

@synthesize lb_card_num = _lb_card_num;
@synthesize lb_card_name = _lb_card_name;
@synthesize card_num = _card_num;
@synthesize card_name = _card_name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _card_num = [[NSString alloc]init];
        _card_name = [[NSString alloc]init];
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
    [_lb_card_num release];
    [_lb_card_name release];
}

- (void)setCard_num:(NSString *)card_num
{
    if (![card_num isEqualToString:_card_num]) {
        _card_num = [card_num copy];
    }
    _lb_card_num.text =_card_num;

}

- (void)setCard_name:(NSString *)card_name
{
    if (![card_name isEqualToString:_card_name]) {
        _card_name = [card_name copy];
    }
    _lb_card_name.text = _card_name;
}

@end
