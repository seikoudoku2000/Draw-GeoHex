//
//  GeoHex.h
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <Foundation/Foundation.h>
#import "Loc.h"
#import "XY.h"
#import "Zone.h"

@interface GeoHex : NSObject {
 
}

+(NSString*) encode:(double)lat longitude:(double)lon level:(int)level;
+(Zone*) getZoneByLocation:(double)lat longitude:(double)lon level:(int)level;
+(double) calcHexSize:(int)level;
+(XY*) loc2xy:(double)lat longitude:(double)lon;
+(Loc*) xy2loc:(double)x yVal:(double)y;
+(NSMutableString*) get3BaseString:(int)orginalInt;
+(int) convertToInt:(NSString*) baseNString baseNumber:(int)baseNumber;

@end
