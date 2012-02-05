//
//  BizListController.m
//  BridgingGood
//
//  Created by ChunJong Park on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BizListController.h"
#import "Business.h"
#import "BizCell.h"
#import "BizDetailController.h"
#import "BizMapController.h"


@implementation BizListController
@synthesize bizList = _bizList;
@synthesize bizListURL = _bizListURL;
@synthesize currBiz = _currBiz;
@synthesize parser = _parser;
@synthesize currBizContent = _currBizContent;
//@synthesize isLoading = _isLoading;
@synthesize loadingDistance = _loadingDistance;
@synthesize prevNumOfBiz = _prevNumOfBiz;
@synthesize startLocation = _startLocation;
@synthesize locationManager = _locationManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.bizList = [[NSMutableArray alloc] init];
    //self.isLoading = NO;
    self.currBiz = [[Business alloc] init];
    self.loadingDistance = 1.0;
    self.prevNumOfBiz = 0;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.startLocation = nil;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.bizList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BizCell";
    
    BizCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.lbName.text = [[self.bizList objectAtIndex:indexPath.row] name];
    cell.lbAddress.text = [[self.bizList objectAtIndex:indexPath.row] address];
    cell.lbDistance.text = [NSString stringWithFormat:@"%.2f mi", [[self.bizList objectAtIndex:indexPath.row] distanceAway]];
    cell.lbCharity.text = [[self.bizList objectAtIndex:indexPath.row] charity];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scroll.contentOffset.y;
    NSInteger maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= -10.0 ) {
        //if (!self.isLoading) {
//            dispatch_queue_t loadQueue = dispatch_queue_create("load business", NULL);
//            dispatch_async(loadQueue, ^{
//                //dispatch_async(dispatch_get_main_queue(), ^{
//                    [self fetchAndParseWithlatitude:self.startLocation.coordinate.latitude longitude:self.startLocation.coordinate.longitude radius:self.loadingDistance];
//                //});
//            });
//            dispatch_release(loadQueue);
        //}
    }
//    else {
//        self.isLoading=NO;
//    }
    
    [super scrollViewDidScroll:scroll];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBizDetail"]) {
        BizDetailController *bizDetail = segue.destinationViewController;
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        [bizDetail setCurrBiz:[self.bizList objectAtIndex:selectedIndex]];
        NSLog(@"lbName.text:%@",[[self.bizList objectAtIndex:selectedIndex] name]);
    } 
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
		self.currBizContent = [NSString string];
	} else if ([elementName isEqualToString:@"businesses"]) {
        self.prevNumOfBiz = [self.bizList count];
		[self.bizList removeAllObjects];
        //[self.tableView reloadData];
	} else {
		self.currBizContent = nil;
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
    
	if([elementName isEqualToString:@"name"]){
		self.currBiz.name = self.currBizContent;
        NSLog(@"name:%@",self.currBizContent);
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
	}else if([elementName isEqualToString:@"businesses"] || [elementName isEqualToString:@"nil-classes"]){
        
		[self.tableView reloadData];
        
        if ([self.bizList count]==self.prevNumOfBiz) {
            if ([self.bizList count]!=0) {
                NSLog(@"re-search!");
            }
            [self fetchAndParseWithlatitude:self.startLocation.coordinate.latitude longitude:self.startLocation.coordinate.longitude radius:self.loadingDistance];
        }
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currBizContent){
		self.currBizContent=string;
	}
}

#pragma mark - Computation
- (void)refresh {
    self.loadingDistance = 0;
    [self.bizList removeAllObjects];
    dispatch_queue_t loadQueue = dispatch_queue_create("load business", NULL);
    dispatch_async(loadQueue, ^{
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchAndParseWithlatitude:self.startLocation.coordinate.latitude longitude:self.startLocation.coordinate.longitude radius:self.loadingDistance];
            [self stopLoading];
        //});
    });
    dispatch_release(loadQueue);
}

-(void) fetchAndParseWithlatitude:(float)lat longitude:(float)lng radius:(float)rad {
    if (self.loadingDistance <= 20)
    {
        ++self.loadingDistance;
        self.bizListURL = [[NSString alloc] initWithFormat: @"http://api.bridginggood.com/business/read.xml?lat=%f&lng=%f&dist=%.1f",lat,lng,rad];
        //self.isLoading = YES;
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:self.bizListURL]];
        [self.parser setDelegate:self];
        [self.parser setShouldProcessNamespaces:YES];
        [self.parser setShouldReportNamespacePrefixes:YES];
        [self.parser setShouldResolveExternalEntities:NO];
        [self.parser parse];
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
        
        MKCoordinateSpan span;
        
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        CLLocationCoordinate2D location;
        location.latitude =self.startLocation.coordinate.latitude;
        location.longitude =self.startLocation.coordinate.longitude;
        dispatch_queue_t loadQueue = dispatch_queue_create("load business", NULL);
        dispatch_async(loadQueue, ^{
            //dispatch_async(dispatch_get_main_queue(), ^{
                [self fetchAndParseWithlatitude:self.startLocation.coordinate.latitude longitude:self.startLocation.coordinate.longitude radius:self.loadingDistance];
            //});
        });
        dispatch_release(loadQueue);
                       
    }
    self.startLocation = newLocation;
}

@end
