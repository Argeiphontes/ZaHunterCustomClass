//
//  Pizzeria.h
//  ZaHunter
//
//  Created by Christopher on 10/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pizzeria : NSObject
@property MKMapItem *mapItem;
@property float distanceFromMe;
@property MKRoute *route;
@property NSInteger rating;

@end
