//
//  BizMapController.m
//  BridgingGood
//
//  Created by ChunJong Park on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BizMapController.h"
#import "BizDetailController.h"

@implementation BizMapAnnotation

@synthesize coordinate=_coordinate;
@synthesize mTitle=_mTitle;
@synthesize mSubTitle=_mSubTitle;

- (NSString *)subtitle{
	return [[NSString alloc]initWithFormat: @"%f/%f", self.coordinate.latitude,self.coordinate.longitude];
}
- (NSString *)title{ return @"Latitude/Longitude"; }

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	self.coordinate=c;
	return self;
}

@end

@implementation BizMapController

@synthesize mapView=_mapView;
@synthesize bizList=_bizList;
@synthesize annotationList=_annotationList;
@synthesize currBiz = _currBiz;
@synthesize parser = _parser;
@synthesize bizListURL = _bizListURL;
@synthesize currBizContent = _currBizContent;
@synthesize locationManager = _locationManager;
@synthesize startLocation = _startLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Annotation
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    //for userLocation blue circle
    if (annotation == mapView.userLocation) 
        return nil;
    
    //for green pin for businesses
    MKPinAnnotationView *aView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                               reuseIdentifier:@"currentloc"];
    aView.pinColor = MKPinAnnotationColorGreen;
    aView.animatesDrop=TRUE;
    aView.canShowCallout = YES;
    aView.calloutOffset = CGPointMake(-5, 5);
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = infoButton;
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"ShowBizDetail" sender:[mapView.selectedAnnotations objectAtIndex:0]];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBizDetail"]) {
        BizDetailController *bizDetail = segue.destinationViewController;
        [bizDetail setCurrBiz:[[Business alloc]init]];
        bizDetail.currBiz.name = @"mcdonald";
    } 
    
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.mapView.delegate = self;
    //[self.mapView setShowsUserLocation:YES];
    
    self.bizList = [[NSMutableArray alloc] init];
    
    [self.mapView setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.startLocation = nil;
    
    self.annotationList = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Mapview

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"will change region %@",animated);
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%f,%f,%f,%f",self.mapView.region.center.latitude,self.mapView.region.center.longitude,self.mapView.region.span.latitudeDelta,self.mapView.region.span.longitudeDelta);
    if (self.mapView.region.span.latitudeDelta < 1 || self.mapView.region.span.longitudeDelta < 1) {
        [self fetchAndParseWithLatitude:self.mapView.region.center.latitude longitude:self.mapView.region.center.longitude radius:[self calculateMileDelta]];
    }
}

#pragma mark - Computation

- (void) fetchAndParseWithLatitude:(float)lat longitude:(float)lng radius:(float)rad {
    self.bizListURL = [[NSString alloc] initWithFormat: @"http://api.bridginggood.com/business/read.xml?lat=%f&lng=%f&dist=%.1f",lat,lng,rad];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:self.bizListURL]];
    [self.parser setDelegate:self];
    [self.parser setShouldProcessNamespaces:YES];
    [self.parser setShouldReportNamespacePrefixes:YES];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
}

-(float) calculateMileDelta{
    float milesFromLat;
    float milesFromLng;
    float scalingFactor = ABS( (cos(2 * M_PI * self.mapView.region.center.latitude / 360.0) ));    
    
    milesFromLat = self.mapView.region.span.latitudeDelta * 69.0;
    milesFromLng = self.mapView.region.span.longitudeDelta * 69.0 * scalingFactor;
    
    if (milesFromLat > milesFromLng) 
        return milesFromLat;
    else 
        return milesFromLng;
}

#pragma mark - NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
	if ([elementName isEqualToString:@"business"]) {
		self.currBiz = [[Business alloc] init];
	} else if([elementName isEqualToString:@"name"] || 
			  [elementName isEqualToString:@"address"] ||
			  [elementName isEqualToString:@"cid"] ||
			  [elementName isEqualToString:@"latitude"] ||
			  [elementName isEqualToString:@"longitude"] ||
              [elementName isEqualToString:@"distance"]) {
		self.currBizContent = [[NSString alloc]init];
	} else if ([elementName isEqualToString:@"businesses"]) {
		[self.bizList removeAllObjects];
	} else {
		self.currBizContent = nil;
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
    NSLog(@"BizContent:%@",self.currBizContent);
	if([elementName isEqualToString:@"name"]){
		self.currBiz.name = self.currBizContent;
	}else if([elementName isEqualToString:@"address"]){
        self.currBiz.address = self.currBizContent;
	}else if([elementName isEqualToString:@"cid"]){
		self.currBiz.charity = self.currBizContent;
	}else if([elementName isEqualToString:@"latitude"]){
		self.currBiz.latitude = [self.currBizContent floatValue];
	}else if([elementName isEqualToString:@"longitude"]){
		self.currBiz.longitude = [self.currBizContent floatValue];
	}else if([elementName isEqualToString:@"distance"]){
		self.currBiz.distanceAway = [self.currBizContent floatValue];
	}else if([elementName isEqualToString:@"business"]){
		[self.bizList addObject:self.currBiz];
	}else if([elementName isEqualToString:@"businesses"]){
        [self.annotationList removeAllObjects];
        for (int i = 0; i < [self.bizList count]; i++) {
            CLLocationCoordinate2D annotationLocation;
            annotationLocation.latitude = [[self.bizList objectAtIndex:i] latitude];
            annotationLocation.longitude = [[self.bizList objectAtIndex:i] longitude];
            [self.annotationList addObject:[[BizMapAnnotation alloc] initWithCoordinate:annotationLocation]];
            [self.mapView addAnnotation:[self.annotationList objectAtIndex:i]];
        }	
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currBizContent){
        NSLog(@"Value:%@",string);
		self.currBizContent=string;
	}
}

#pragma mark - CLLocation

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{    
    if (self.startLocation == nil){
        self.startLocation = newLocation;
        NSLog(@"%f, %f",self.startLocation.coordinate.latitude,self.startLocation.coordinate.longitude);

        MKCoordinateRegion region;
        MKCoordinateSpan span;
        
        span.latitudeDelta=0.0145;
        span.longitudeDelta=0.0145;
        CLLocationCoordinate2D location;
        location.latitude =self.startLocation.coordinate.latitude;
        location.longitude =self.startLocation.coordinate.longitude;
        
        region.span=span;
        region.center=location;
        
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView regionThatFits:region];
        
        //[self fetchAndParseWithLatitude:location.latitude longitude:location.longitude radius:8.0];
    }
    self.startLocation = newLocation;

}


@end
