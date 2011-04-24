//
//  GeoHexSampleViewController.m
//  GeoHexSample
//
//  Created by mac_tomita on 11/02/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "GeoHexSampleViewController.h"
#import "GeoHex.h"
#import "Zone.h"

@implementation GeoHexSampleViewController
@synthesize mapView = mapView_;
@synthesize modeControl;
@synthesize mapControl;
@synthesize levelLabel;
@synthesize plusButton;
@synthesize minusButton;
@synthesize resetButton;
@synthesize adView;

UIPanGestureRecognizer *panGesture;
int level;
NSMutableSet *hexCodeSet;
NSMutableArray *polyArray;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	mapView_.delegate = self;
	MKCoordinateRegion region = mapView_.region;
	region.span.latitudeDelta = 0.05; // 地図の表示倍率
	region.span.longitudeDelta = 0.05;
	region.center = CLLocationCoordinate2DMake(35.658517, 139.701334); //near Shibuya,Tokyo
	[mapView_ setRegion:region animated:YES];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];  
	[mapView_ addGestureRecognizer:tapGesture];  
	[tapGesture release];  

	panGesture = [[UIPanGestureRecognizer alloc] 
				  initWithTarget:self 
				  action:@selector(handlePanGesture:)];
	level = [[levelLabel text] intValue];
	hexCodeSet = [[NSMutableSet set] retain];
	polyArray = [[NSMutableArray alloc] init];
	adView.delegate = self;
}


- (void) handlePanGesture:(UIPanGestureRecognizer*)sender {  
	CGPoint location = [sender locationInView:mapView_];
	CLLocationCoordinate2D mapPoint = [mapView_ convertPoint:location toCoordinateFromView:mapView_];
	[self drawHex:mapPoint.latitude lon:mapPoint.longitude level:level];
} 


- (void) handleTapGesture:(UITapGestureRecognizer*)sender {  
	CGPoint location = [sender locationInView:mapView_];
	//NSLog(@"tap: x:%f, y:%f", location.x, location.y );
	CLLocationCoordinate2D mapPoint = [mapView_ convertPoint:location toCoordinateFromView:mapView_];
	//NSLog(@"tap: x:%f, y:%f", mapPoint.latitude, mapPoint.longitude);
	[self drawHex:mapPoint.latitude lon:mapPoint.longitude level:level];
} 


-(void) drawHex:(double)lat lon:(double)lon level:(int)level {
	Zone *zone = [GeoHex getZoneByLocation:lat longitude:lon level:level];
	if([hexCodeSet containsObject: zone.code] == FALSE) {
		NSArray *locArray = [zone getHexCoords];
		CLLocationCoordinate2D coors[6];
		coors[0] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:0]).lat,((Loc*)[locArray objectAtIndex:0]).lon);
		coors[1] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:1]).lat,((Loc*)[locArray objectAtIndex:1]).lon);
		coors[2] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:2]).lat,((Loc*)[locArray objectAtIndex:2]).lon);
		coors[3] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:3]).lat,((Loc*)[locArray objectAtIndex:3]).lon);
		coors[4] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:4]).lat,((Loc*)[locArray objectAtIndex:4]).lon);
		coors[5] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:5]).lat,((Loc*)[locArray objectAtIndex:5]).lon);
		MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coors count:6];
		[mapView_ addOverlay:polygon];
		[hexCodeSet addObject:zone.code];
		[polyArray addObject:polygon];
	}
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
	MKPolygonView *view = [[[MKPolygonView alloc] initWithOverlay:overlay] autorelease];
	view.strokeColor = [UIColor orangeColor];
	view.lineWidth = 1.0;
	view.fillColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:0.3];
	return view;
}

-(IBAction)changeLevel:(UIButton *)sender {
	NSString *buttonText = [[sender titleLabel] text];
	level = [[levelLabel text] intValue];
	if ([buttonText isEqual:@"＋"]) {
		if (level <= 14) {
			level ++;
			[levelLabel setText:[NSString stringWithFormat:@"%d", level]];
			if(level == 15) {
				[plusButton setEnabled:FALSE];
			} else {
				[plusButton setEnabled:TRUE];
				[minusButton setEnabled:TRUE];
			}
		}
	} else if([buttonText isEqual:@"ー"]) {
		if (level >= 1) {
			level --;
			[levelLabel setText:[NSString stringWithFormat:@"%d", level]];
			if(level == 0) {
				[minusButton setEnabled:FALSE];
			} else {
				[plusButton setEnabled:TRUE];
				[minusButton setEnabled:TRUE];
			}
		}
	}
}

-(IBAction)changeMode:(UISegmentedControl *)sender {
	if ([sender selectedSegmentIndex] == 0) {
		mapView_.scrollEnabled = TRUE;
		[mapView_ removeGestureRecognizer:panGesture];
	} else {
		mapView_.scrollEnabled = FALSE;
		[mapView_ addGestureRecognizer:panGesture];  
	}
}

-(IBAction)changeMap:(UISegmentedControl *)sender {
	mapView_.mapType = sender.selectedSegmentIndex;
}

-(IBAction)resetMap:(UIButton *)sender {
	for (MKPolygon* poly in polyArray) {
		[mapView_ removeOverlay:poly];
	}
	[polyArray removeAllObjects];
	[hexCodeSet removeAllObjects];
}


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	return YES;
}

	
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	banner.frame = CGRectOffset( banner.frame, 0.0, -50.0 );
	[UIView commitAnimations];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[panGesture release];
	[hexCodeSet release];
	[polyArray release];
	adView.delegate = nil;
	[super dealloc];
}

@end
