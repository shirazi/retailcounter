//
//  ViewController.m
//  RCClient
//
//  Created by Dimitris Togias on 2/4/15.
//  Copyright (c) 2015 RC Ltd. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "KontaktSDK.h"
#import <Parse/Parse.h>

static NSString *const UNIVERSAL_UUID   = @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";

////////////////////////////////////////////////////////////////////////////////
@interface ViewController () <KTKLocationManagerDelegate>

@property(nonatomic, strong) KTKLocationManager *locationManager;
@property(nonatomic, strong) NSMutableDictionary *nearBeacons;
@property(nonatomic, assign) NSUInteger totalCounter;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation ViewController

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationManager = [KTKLocationManager new];
    self.nearBeacons = [NSMutableDictionary new];
    if ([KTKLocationManager canMonitorBeacons]) {
        
        KTKRegion *region = [KTKRegion new];
        region.uuid = UNIVERSAL_UUID;
        
        [self.locationManager setRegions:@[ region ]];
        self.locationManager.delegate = self;
    }
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.locationManager startMonitoringBeacons];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.locationManager stopMonitoringBeacons];
}

#pragma mark - KTKLocationManagerDelegate
////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(KTKLocationManager *)locationManager didChangeState:(KTKLocationManagerState)state withError:(NSError *)error
{
    NSLog(@"didChangeState");
}

////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(KTKLocationManager *)locationManager didEnterRegion:(KTKRegion *)region
{
    NSLog(@"didEnterRegion");
}

////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(KTKLocationManager *)locationManager didExitRegion:(KTKRegion *)region
{
    NSLog(@"didExitRegion");
}

////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(KTKLocationManager *)locationManager didRangeBeacons:(NSArray *)beacons
{
    NSLog(@"didRangeBeacons: %@", beacons);
    [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CLBeacon *beacon = ( CLBeacon*) obj;
        NSString *beaconHashKey = [NSString stringWithFormat:@"%@:%@", beacon.major, beacon.minor];
        CLBeacon *savedBeacon = self.nearBeacons[beaconHashKey];
        
        // Beacon didEnter
        if (beacon.proximity == CLProximityImmediate && savedBeacon == nil) {
            self.nearBeacons[beaconHashKey] = beacon;
            self.totalCounter++;
            self.countNumberLabel.text = [NSString stringWithFormat:@"%d", self.totalCounter];
            return;
        }
        
        if (beacon.proximity == CLProximityFar && savedBeacon) {
            [self.nearBeacons removeObjectForKey:beaconHashKey];
            return;
        }
        
//        if (beacon.proximity == CLProximityImmediate) {
//            NSLog(@"Immediate Beacon %@", beacon);
//            PFObject *beaconData = [PFObject objectWithClassName:@"BeaconData"];
//            
//            beaconData[@"major"] = beacon.major;
//            beaconData[@"minor"] = beacon.minor;
//            [beaconData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    NSLog(@"Object SAVED to Parse");
//                } else {
//                    NSLog(@"Object FAILED to save to Parse");
//                }
//            }];
//        }
    }];
}

@end
