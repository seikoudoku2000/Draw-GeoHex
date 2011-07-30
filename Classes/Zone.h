//
//  Zone.h
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <Foundation/Foundation.h>

 
@interface Zone : NSObject {
	double lat;
	double lon;
	long x;
	long y;
	NSString *code;
	int level;
}

@property double lat,lon;
@property long x,y;
@property(retain,nonatomic) NSString *code;
@property int level;
-(NSArray*) getHexCoords;

@end
