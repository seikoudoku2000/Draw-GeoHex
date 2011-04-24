//
//  GeoHexSampleAppDelegate.h
//  GeoHexSample
//
//  Created by mac_tomita on 11/02/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <UIKit/UIKit.h>

@class GeoHexSampleViewController;

@interface GeoHexSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GeoHexSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GeoHexSampleViewController *viewController;

@end

