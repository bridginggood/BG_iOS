//
//  BizDetailController.h
//  BridgingGood
//
//  Created by ChunJong Park on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
@interface BizDetailController : UIViewController
//{
//    UILabel *name;
//    UILabel *address;
//    UILabel *charity;
//}

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *address;
@property (nonatomic, strong) IBOutlet UILabel *charity;
@property (nonatomic, strong) Business *currBiz;

@end
