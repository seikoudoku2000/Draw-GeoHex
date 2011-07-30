//
//  Zone.m
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "Zone.h"
#import "GeoHex.h"
#import "XY.h"
 
@implementation Zone

@synthesize lon,lat,x,y,code,level;

-(double) getHexSize {
	return [GeoHex calcHexSize:self.level + 2];
}

-(NSArray*) getHexCoords {
	double h_lat = self.lat;
	double h_lon = self.lon;
	XY *h_xy = [GeoHex loc2xy:h_lat longitude:h_lon];
	double h_x = h_xy.x;
	double h_y = h_xy.y;
	double h_deg = tan(M_PI * (60.0 / 180.0));
	double h_size = [self getHexSize];
	
	double h_top = [GeoHex xy2loc:h_x yVal:h_y + h_deg * h_size].lat;
	double h_btm = [GeoHex xy2loc:h_x yVal:h_y - h_deg * h_size].lat;
	double h_l = [GeoHex xy2loc:h_x-2 * h_size yVal:h_y].lon;
	double h_r = [GeoHex xy2loc:h_x+2 * h_size yVal:h_y].lon;
	double h_cl = [GeoHex xy2loc:h_x-1 * h_size yVal:h_y].lon;
	double h_cr = [GeoHex xy2loc:h_x+1 * h_size yVal:h_y].lon;

	return [NSArray arrayWithObjects:
			[Loc getLoc:h_lat : h_l],
			[Loc getLoc:h_top : h_cl],
			[Loc getLoc:h_top : h_cr],
			[Loc getLoc:h_lat : h_r],
			[Loc getLoc:h_btm : h_cr],
			[Loc getLoc:h_btm : h_cl],
			nil];
	
}

@end
