//
//  ViewController.h
//  objcgps
//
//  Created by Jesse Liang on 4/24/16.
//  Copyright © 2016 Jesse Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController


@end
@implementation ViewController

NSData *latest;

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
            //Update UI
        });
    });
}



@end

