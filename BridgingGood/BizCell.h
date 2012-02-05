//
//  BizCell.h
//  BridgingGood
//
//  Created by ChunJong Park on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BizCell : UITableViewCell
//{
//    UILabel *lbName;
//    UILabel *lbDistance;
//    UILabel *lbAddress;
//    UILabel *lbCharity;
//}

@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UILabel *lbDistance;
@property (nonatomic, strong) IBOutlet UILabel *lbAddress;
@property (nonatomic, strong) IBOutlet UILabel *lbCharity;

@end
