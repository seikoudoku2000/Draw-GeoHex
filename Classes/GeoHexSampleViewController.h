//
//  GeoHexSampleViewController.h
//  GeoHexSample
//
//  Created by mac_tomita on 11/02/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@interface GeoHexSampleViewController : UIViewController  <MKMapViewDelegate, ADBannerViewDelegate>{
	MKMapView *mapView;
	UISegmentedControl *modeControl;
	UISegmentedControl *mapControl;
	UILabel *levelLabel;
	UIButton *plusButton;
	UIButton *minusButton;
	UIButton *resetButton;
	ADBannerView *adView;
}

@property (assign) IBOutlet MKMapView *mapView;
@property (assign) IBOutlet UISegmentedControl *modeControl;
@property (assign) IBOutlet UISegmentedControl *mapControl;
@property (assign) IBOutlet UILabel *levelLabel;
@property (assign) IBOutlet UIButton *plusButton;
@property (assign) IBOutlet UIButton *minusButton;
@property (assign) IBOutlet UIButton *resetButton;
@property (assign) IBOutlet ADBannerView *adView;
-(void) drawHex:(double)lat lon:(double)lon level:(int)level;
-(IBAction)changeLevel:(UIButton *)sender;
-(IBAction)changeMode:(UISegmentedControl *)sender;
-(IBAction)changeMap:(UISegmentedControl *)sender;
-(IBAction)resetMap:(UIButton *)sender;
@end

