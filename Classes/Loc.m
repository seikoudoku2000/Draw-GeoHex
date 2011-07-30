//
//  Loc.m
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "Loc.h"

 
@implementation Loc
@synthesize lat,lon;

+(Loc*) getLoc:(double)lat :(double)lon {
	Loc *loc = [[[Loc alloc] init] autorelease];
	loc.lat = lat;
	loc.lon = lon;
	return loc;
}

@end
