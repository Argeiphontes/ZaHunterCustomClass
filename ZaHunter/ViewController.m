//
//  ViewController.m
//  ZaHunter
//
//  Created by Christopher on 10/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Pizzeria.h"

@interface ViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property CLLocationManager *myLocationManager;
@property NSMutableArray *pizzeriaArray;
@property CLLocation *myLocation;
@property NSNumberFormatter *numberFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pizzeriaArray = [NSMutableArray array];
    self.myLocationManager = [[CLLocationManager alloc]init];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}

#pragma - Table View & Buttons
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pizzeriaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Pizzeria *pizzeria = [self.pizzeriaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = pizzeria.mapItem.name;
    cell.detailTextLabel.text = pizzeria.distanceFromMeInKM;

//        cell.detailTextLabel.text = pizzeria.distanceFromMe;


        return cell;

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.textLabel.text = [self.pizzeriaArray objectAtIndex:indexPath.row];

}

- (IBAction)huntZaButtonPressed:(id)sender
{
    [self.myLocationManager startUpdatingLocation];
    NSLog(@"Locating you...");
}


# pragma Location Manager & MKLocalSearchRequest
// find user location  input: Location (from CLLocationManager) output: call findPizzaNearby
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            [self findPizzaNearby: location];
            self.myLocation = location;
            NSLog(@"The Location is %@", location);
            [self.myLocationManager stopUpdatingLocation];
            break;

        }
    }
}

// find pizza locations   input: MKLocalSearchRequest  Output: mapItems made into Pizzeria objects and assigned to array
-(void) findPizzaNearby: (CLLocation *) location
{

    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(3, 3));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {

        for (MKMapItem *mapItem in response.mapItems) {
            Pizzeria *pizzeria = [Pizzeria new];
            pizzeria.mapItem = mapItem;
            // calculate distanceFromMe, route, and add ratings
            pizzeria.distanceFromMe = [self calculatePizzeriaDistances: pizzeria];  // Study this connection.
            pizzeria.distanceFromMeInKM = [NSString stringWithFormat:@"%.02f km", pizzeria.distanceFromMe];


// NSString* myNewString = [NSString stringWithFormat:@"%d", myInt];
            // NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
            [self.pizzeriaArray addObject:pizzeria];

        }
        [self.tableView reloadData];
    }];
}


#pragma - Helper Methods

// calculate & sort distance of pizzerias from User (ascending)  input: locations  output: distances
- (CLLocationDistance) calculatePizzeriaDistances: (Pizzeria *) pizzeria
{

        // If pizzeria distance is within range show it. We want it closer than 6.21371 miles or 10 kilometers

//        Pizzeria *pizzeria = [Pizzeria new];

    CLLocation *myCurrentLocation = self.myLocation;
    CLLocation *pizzeriaLocation = pizzeria.mapItem.placemark.location;
    CLLocationDistance distance = [pizzeriaLocation distanceFromLocation: myCurrentLocation];
    NSLog(@"Distance is %f", distance);
    distance = distance / 1000;
    NSString *distanceWhenFormatted = [self.numberFormatter stringFromNumber:@(distance)];
    distanceWhenFormatted = [distanceWhenFormatted stringByAppendingString:@" kilometers"];

    //         = [NSString stringWithFormat:@"%.20f", distance];

    return distance;

}

// view pizzerias in MapView
-(void) placePizzeriaPins {
    
}

// calculate walk & drive times to each pizzeria input: distances  output: times
- (void) calculateWalkAndDriveTimes
{
    
}

// Assign ratings to each Pizzeria Object  input:  JSON?  output:  ratings
-(void) fetchPizzeriaRatings
{

}

// Calculate total time to visit all pizzerias  input: routes  output:  time
-(void) calculatePubCrawl
{

}


@end
