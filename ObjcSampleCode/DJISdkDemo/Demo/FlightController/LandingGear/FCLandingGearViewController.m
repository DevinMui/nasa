//
//  FCLandingGearViewController.m
//  DJISdkDemo
//
//  Copyright © 2015 DJI. All rights reserved.
//
/**
 *  DJILandingGear is one of property of DJIFlightController. Currently, it is only available for Inspire 1 or Inspire 1 Pro. This file
 *  demonstrates how to control the physical landing gear of the aircraft.
 */
#import "DemoUtility.h"
#import <DJISDK/DJISDK.h>
#import "FCLandingGearViewController.h"

@interface FCLandingGearViewController () <DJIFlightControllerDelegate>

@property (assign, nonatomic) DJILandingGearMode landingGearMode;
@property (assign, nonatomic) DJILandingGearStatus landingGearStatus;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

- (IBAction)onTurnOnButtonClicked:(id)sender;
- (IBAction)onTurnOffButtonClicked:(id)sender;
- (IBAction)onEnterTransportButtonClicked:(id)sender;
- (IBAction)onExitTransportButtonClicked:(id)sender;

@end

@implementation FCLandingGearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.landingGearMode = DJILandingGearModeUnknown;
    self.landingGearStatus = DJILandingGearStatusUnknown;
    
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];
    if (fc) {
        fc.delegate = self;
    }
}

- (IBAction)onTurnOnButtonClicked:(id)sender {
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];
    DJILandingGear* landingGear = fc.landingGear;
    if (landingGear) {
        [landingGear turnOnAutoLandingGearWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Turn on:%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

- (IBAction)onTurnOffButtonClicked:(id)sender {
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];
    DJILandingGear* landingGear = fc.landingGear;
    if (landingGear) {
        [landingGear turnOffAutoLandingGearWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Turn Off:%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

- (IBAction)onEnterTransportButtonClicked:(id)sender {
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];
    DJILandingGear* landingGear = fc.landingGear;
    if (landingGear) {
        [landingGear enterTransportModeWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Enter Transport:%@", error);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

- (IBAction)onExitTransportButtonClicked:(id)sender {
    DJIFlightController* fc = [DemoComponentHelper fetchFlightController];
    DJILandingGear* landingGear = fc.landingGear;
    if (landingGear) {
        [landingGear exitTransportModeWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Exit Transport:%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

- (void)flightController:(DJIFlightController *)fc didUpdateSystemState:(DJIFlightControllerCurrentState *)state
{
    DJILandingGear* landingGear = fc.landingGear;
    if (landingGear.mode != _landingGearMode) {
        _landingGearMode = landingGear.mode;
        self.modeLabel.text = [self stringWithLandingGearMode:_landingGearMode];
    }
    
    if (landingGear.status != _landingGearStatus) {
        _landingGearStatus = landingGear.status;
        self.statusLabel.text = [self stringWithLandingGearStatus:_landingGearStatus];
    }
}

-(NSString*) stringWithLandingGearMode:(DJILandingGearMode)mode
{
    if (mode == DJILandingGearModeAuto) {
        return @"Auto";
    }
    else if (mode == DJILandingGearModeNormal)
    {
        return @"Normal";
    }
    else if (mode == DJILandingGearModeTransport)
    {
        return @"Transport";
    }
    else
    {
        return @"N/A";
    }
}

-(NSString*) stringWithLandingGearStatus:(DJILandingGearStatus)status
{
    if (status == DJILandingGearStatusDeployed) {
        return @"Deployed";
    }
    else if (status == DJILandingGearStatusDeploying)
    {
        return @"Deploying";
    }
    else if (status == DJILandingGearStatusRetracted)
    {
        return @"Retracted";
    }
    else if (status == DJILandingGearStatusRetracting)
    {
        return @"Retracting";
    }
    else if (status == DJILandingGearStatusStopped)
    {
        return @"Stoped";
    }
    else
    {
        return @"N/A";
    }
}
@end
