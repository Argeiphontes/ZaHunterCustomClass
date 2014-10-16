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
@property NSArray *pizzerias;
@property CLLocation *myLocation;
@property NSNumberFormatter *numberFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pizzerias = [NSMutableArray array];
    self.myLocationManager = [[CLLocationManager alloc]init];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pizzerias.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.pizzerias.count) {

        MKMapItem *pizzeria = [self.pizzerias objectAtIndex:indexPath.row];

        // If pizzeria distance is within range show it. We want it closer than 6.21371 miles or 10 kilometers

        CLLocation *myCurrentLocation = self.myLocation;
        CLLocation *pizzeriaLocation = pizzeria.placemark.location;
        CLLocationDistance distance = [pizzeriaLocation distanceFromLocation: myCurrentLocation];
        NSString *distanceFromMe = [self.numberFormatter stringFromNumber:@(distance)];
        distanceFromMe = [distanceFromMe stringByAppendingString:@" meters"];
//         = [NSString stringWithFormat:@"%.20f", distance];
        cell.textLabel.text = pizzeria.name;
        cell.detailTextLabel.text = distanceFromMe;
    }
        return cell;
}

- (IBAction)huntZaButtonPressed:(id)sender
{
    [self.myLocationManager startUpdatingLocation];
    NSLog(@"Locating you...");
}

// find user location
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

// find pizza locations
-(void) findPizzaNearby: (CLLocation *) location
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(5, 5));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.pizzerias = response.mapItems;
        [self.tableView reloadData];
    }];
}



@end
