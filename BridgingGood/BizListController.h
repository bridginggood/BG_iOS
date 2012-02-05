//
//  BizListController.h
//  BridgingGood
//
//  Created by ChunJong Park on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Business.h"
#import "PullRefreshTableViewController.h"

//@interface BizListController : UITableViewController <NSXMLParserDelegate,CLLocationManagerDelegate>
@interface BizListController : PullRefreshTableViewController <NSXMLParserDelegate,CLLocationManagerDelegate>
//{
//    Business *currBiz;
//    NSString *currBizContent;
//    NSMutableArray *bizList;
//    NSString *bizListURL;
//    NSXMLParser *parser;
//}

@property (nonatomic, strong) NSMutableArray *bizList;
@property (nonatomic, strong) Business *currBiz;
@property (nonatomic, strong) NSString *bizListURL;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *currBizContent;
//@property (nonatomic) BOOL isLoading;
@property (nonatomic) float loadingDistance;
@property (nonatomic) int prevNumOfBiz;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

-(void) fetchAndParseWithlatitude:(float)lat longitude:(float)lng radius:(float)rad;

@end
