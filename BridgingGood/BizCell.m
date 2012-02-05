//
//  BizCell.m
//  BridgingGood
//
//  Created by ChunJong Park on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BizCell.h"

@implementation BizCell

@synthesize lbName = _lbName;
@synthesize lbAddress = _lbAddress;
@synthesize lbDistance = _lbDistance;
@synthesize lbCharity = _lbCharity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        lbName = [[UILabel alloc]init];
//        lbAddress = [[UILabel alloc]init];
//        lbCharity = [[UILabel alloc]init];
//        lbDistance = [[UILabel alloc]init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
