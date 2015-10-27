//
//  DeviceTableViewCell.h
//  FCARD
//
//  Created by FREELANCER on 14-7-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lb_sn;
@property (nonatomic, retain) IBOutlet UILabel *lb_m1;
@property (nonatomic, retain) IBOutlet UILabel *lb_m2;
@property (nonatomic, retain) IBOutlet UILabel *lb_m3;
@property (nonatomic, retain) IBOutlet UILabel *lb_m4;

@property (retain, nonatomic) IBOutlet UILabel *lbM2;
@property (retain, nonatomic) IBOutlet UILabel *lbM3;
@property (retain, nonatomic) IBOutlet UILabel *lbM4;


@property (nonatomic ,copy) NSString *sn;
@property (nonatomic, copy) NSString *m1;
@property (nonatomic, copy) NSString *m2;
@property (nonatomic, copy) NSString *m3;
@property (nonatomic, copy) NSString *m4;
- (void)hidden1;
- (void)hidden2;
@end
