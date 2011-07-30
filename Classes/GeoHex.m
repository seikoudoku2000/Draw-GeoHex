//
//  GeoHex.m
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "GeoHex.h"

@implementation GeoHex;

#define H_BASE 20037508.34
#define H_DEG M_PI*(30.0/180.0)
#define H_K tan(H_DEG)
#define H_KEY @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

+(double) calcHexSize:(int)level {
	return H_BASE/pow(3.0, (double)level +1);
} 

+(XY*) loc2xy:(double)lat longitude:(double)lon {
	double x = lon * H_BASE / 180.0;
	double y = log(tan((90.0 + lat) * M_PI / 360.0)) / (M_PI / 180.0);
	y *= H_BASE / 180.0;
	XY *xy = [[XY alloc] init];
	xy.x = x;
	xy.y = y;
	return [xy autorelease];
}

+(Loc*) xy2loc:(double)x yVal:(double)y {
	double lon = (x / H_BASE) * 180.0;
	double lat = (y / H_BASE) * 180.0;
	lat = 180 / M_PI * (2.0 * atan(exp(lat * M_PI / 180.0)) - M_PI / 2.0);
	Loc *loc = [[Loc alloc] init];
	loc.lat = lat;
	loc.lon = lon;
	return [loc autorelease];
}

+(NSMutableString*) get3BaseString:(int)orginalInt {
	int sansin[16]; 
	for(int i=0; i<16; i++){
        sansin[i] = orginalInt % 3;    
        orginalInt = orginalInt / 3;
    } 
	NSMutableString *ans = [NSMutableString string];
    for(int i=16-1; i>=0; i--){
        [ans appendFormat:@"%d", sansin[i]];
    } 
	return ans;
}

+(int) convertToInt:(NSString*) baseNString baseNumber:(int)baseNumber {
	int result = 0;
	for (int i = [baseNString length] - 1; i >= 0 ; i--) {
		int nextVal = [[baseNString substringWithRange:NSMakeRange(i, 1)] intValue];
		result += pow(baseNumber,[baseNString length] - 1 - i) * nextVal;
	}
	return result;
}

+(NSString*) encode:(double)lat longitude:(double)lon level:(int)level {
	Zone* zone = [GeoHex getZoneByLocation:lat longitude:lon level:level];
	return zone.code;
}

+(Zone*) getZoneByLocation:(double)lat longitude:(double)lon level:(int)level {
	if (lat < -90 || lat > 90) {
		NSException *exception = [NSException exceptionWithName:@"IllegalArgumentException"
								   reason:@"latitude must be between -90 and 90" userInfo:nil];
		@throw exception;
	} else if (lon < -180 || lon > 180) {
		NSException *exception = [NSException exceptionWithName:@"IllegalArgumentException"
														 reason:@"longitude must be between -180 and 180" userInfo:nil];
		@throw exception;
	} else if(level < 0 || level > 15){
		NSException *exception = [NSException exceptionWithName:@"IllegalArgumentException"
														 reason:@"level must be between 0 and 15" userInfo:nil];
		@throw exception;
	}
	
	level += 2;
	double h_size = [GeoHex calcHexSize:level];
	
	
	XY *z_xy = [GeoHex loc2xy:lat longitude:lon];
	double lon_grid = z_xy.x;
	double lat_grid = z_xy.y;
	double unit_x = 6 * h_size;
	double unit_y = 6 * h_size * H_K;
	double h_pos_x = (lon_grid + lat_grid / H_K) / unit_x;
	double h_pos_y = (lat_grid - H_K * lon_grid) / unit_y;
	long h_x_0 = floor(h_pos_x);
	long h_y_0 = floor(h_pos_y);
	double h_x_q = h_pos_x - h_x_0;
	double h_y_q = h_pos_y - h_y_0;
	long h_x = round(h_pos_x);
	long h_y = round(h_pos_y);
	
	if (h_y_q > -h_x_q + 1) {
		if((h_y_q < 2 * h_x_q) && (h_y_q > 0.5 * h_x_q)){
			h_x = h_x_0 + 1;
			h_y = h_y_0 + 1;
		}
	} else if (h_y_q < -h_x_q + 1) {
		if ((h_y_q > (2 * h_x_q) - 1) && (h_y_q < (0.5 * h_x_q) + 0.5)){
			h_x = h_x_0;
			h_y = h_y_0;
		}
	}
	
	double h_lat = (H_K * h_x * unit_x + h_y * unit_y) / 2;
	double h_lon = (h_lat - h_y * unit_y) / H_K;

	
	Loc *z_loc = [GeoHex xy2loc:h_lon yVal:h_lat];
	double z_loc_x = z_loc.lon;
	double z_loc_y = z_loc.lat;

	if(H_BASE - h_lon < h_size){
		z_loc_x = 180;
		long h_xy = h_x;
		h_x = h_y;
		h_y = h_xy;
	}
	
	NSMutableString *h_code = [NSMutableString string];
	NSMutableArray *code3_x = [[NSMutableArray alloc] init];
	NSMutableArray *code3_y = [[NSMutableArray alloc] init];
	NSMutableString *code3 = [NSMutableString string];
	NSMutableString *code9 = [NSMutableString string];
	long mod_x = h_x;
	long mod_y = h_y;
	
	for (int i=0; i <= level; i++) {
		double h_pow = pow(3, level - i);
		
		if (mod_x >= ceil(h_pow/2)) {
			[code3_x addObject:[NSNumber numberWithInt:2]];
			 mod_x -= h_pow;
		} else if(mod_x <= -ceil(h_pow/2)){
			[code3_x addObject:[NSNumber numberWithInt:0]];
			 mod_x += h_pow;
		} else {
			[code3_x addObject:[NSNumber numberWithInt:1]];
		}
		
		if(mod_y >= ceil(h_pow/2)) {
			[code3_y addObject:[NSNumber numberWithInt:2]];
			mod_y -= h_pow;
		} else if(mod_y <= -ceil(h_pow/2)){
			[code3_y addObject:[NSNumber numberWithInt:0]];
			mod_y += h_pow;
		} else {
			[code3_y addObject:[NSNumber numberWithInt:1]];
		}
	}

	 
	for (int i=0; i < [code3_x count]; i++) {
		NSString *s1 = [NSString stringWithFormat : @"%d",[[code3_x objectAtIndex:i] intValue]];
		NSString *s2 = [NSString stringWithFormat : @"%d",[[code3_y objectAtIndex:i] intValue]]; 
		NSString *str = [NSString stringWithFormat:@"%@%@",s1,s2];
		[code3 appendString:str];
		[code9 appendString:[NSString stringWithFormat : @"%d", [GeoHex convertToInt:code3 baseNumber:3]]];
		[h_code appendString: code9];

		code3 = [NSMutableString string];
		code9 = [NSMutableString string];
	}
	
	
	NSString *h_2 = [h_code substringFromIndex:3];
	int h_1 = [[h_code substringToIndex:3] intValue];
	int h_a1 = (int)floor(h_1/30);
	int h_a2 = h_1%30;

	NSMutableString *h_code_r = [NSMutableString string];
	[h_code_r appendString: [H_KEY substringWithRange:NSMakeRange(h_a1,1)]];
	[h_code_r appendString: [H_KEY substringWithRange:NSMakeRange(h_a2,1)]];
	[h_code_r appendString: h_2];
		
	Zone *zone = [[Zone alloc] init];
	zone.lat = z_loc_y;
	zone.lon = z_loc_x;
	zone.x = h_x;
	zone.y = h_y;
	zone.level = [h_code_r length] - 2;
	zone.code = h_code_r;
	return [zone autorelease];
}


@end
