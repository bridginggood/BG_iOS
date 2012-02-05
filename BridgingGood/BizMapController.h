//
//  BizMapController.h
//  BridgingGood
//
//  Created by ChunJong Park on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Business.h"

@interface BizMapAnnotation : NSObject <MKAnnotation> 
//{
//	CLLocationCoordinate2D coordinate;
//	
//	NSString *mTitle;
//	NSString *mSubTitle;
//}
@property (nonatomic, strong) NSString *mTitle;
@property (nonatomic, strong) NSString *mSubTitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@interface BizMapController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSXMLParserDelegate>
//{
//    MKMapView *mapView;
//}

@property (nonatomic, strong) NSMutableArray *bizList;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotationList;
@property (nonatomic, strong) NSString *bizListURL;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) Business *currBiz;
@property (nonatomic, strong) NSString *currBizContent;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

-(void) fetchAndParseWithLatitude:(float)lat longitude:(float)lng radius:(float)rad;
-(float) calculateMileDelta;

@end


