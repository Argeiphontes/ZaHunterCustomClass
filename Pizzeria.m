//
//  Pizzeria.m
//  ZaHunter
//
//  Created by Christopher on 10/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "Pizzeria.h"

@implementation Pizzeria
-(instancetype)initWithMapItem: (MKMapItem *) passedInMapItem distanceFromMe: (CLLocationDistance)passedInDistanceFromMe distanceFromMeInKM: (NSString *) passedInDistanceFromMeInKM
{
    self = [super init];
    if (self) {
        self.mapItem = passedInMapItem;
        self.distanceFromMe = passedInDistanceFromMe;
        self.distanceFromMeInKM = passedInDistanceFromMeInKM;
    }
    return self;
}

@end
