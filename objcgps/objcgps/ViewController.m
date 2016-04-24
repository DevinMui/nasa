//
//  ViewController.m
//  objcgps
//
//  Created by Jesse Liang on 4/24/16.
//  Copyright © 2016 Jesse Liang. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSData *latest;
CLLocationManager *locationManager;
NSString *latitudeData;
NSString *longitudeData;

- (void)startTimedTask
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString = @"http://nasa.devinmui.xyz/latest";
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        latest = responseObject;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        latest = error;
    }];
    NSTimer *fiveSecondTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = @"http://nasa.devinmui.xyz/latest";
        
        
        //NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
        
        //[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if(responseObject == latest){
                // fly the drone
                // get responseObject.long, responseObject.lat
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];  //requesting location updates
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    latitudeData = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    longitudeData = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
}
@end
