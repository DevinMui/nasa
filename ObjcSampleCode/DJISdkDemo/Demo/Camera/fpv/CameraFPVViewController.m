//
//  CameraFPVViewController.m
//  DJISdkDemo
//
//  Copyright © 2015 DJI. All rights reserved.
//
/**
 *  This file demonstrates how to receive the video data from DJICamera and display the video using VideoPreviewer.
 */
#import "CameraFPVViewController.h"
#import "DemoUtility.h"
#import <VideoPreviewer/VideoPreviewer.h>
#import <DJISDK/DJISDK.h>

@interface CameraFPVViewController () <DJICameraDelegate>

@property(nonatomic, weak) IBOutlet UIView* fpvView;
@property (weak, nonatomic) IBOutlet UIView *fpvTemView;
@property (weak, nonatomic) IBOutlet UISwitch *fpvTemEnableSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fpvTemperatureData;

@property(nonatomic, assign) BOOL needToSetMode;

@end

@implementation CameraFPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DJICamera* camera = [DemoComponentHelper fetchCamera];
    if (camera) {
        camera.delegate = self;
    }

    self.needToSetMode = YES;
    
    [[VideoPreviewer instance] start];
    [[VideoPreviewer instance] setDecoderWithProduct:[DemoComponentHelper fetchProduct] andDecoderType:VideoPreviewerDecoderTypeSoftwareDecoder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[VideoPreviewer instance] setView:self.fpvView];
    
    [self updateThermalCameraUI]; 
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Call unSetView during exiting to release the memory.
    [[VideoPreviewer instance] unSetView];
}


/**
 *  VideoPreviewer is used to decode the video data and display the decoded frame on the view. VideoPreviewer provides both software 
 *  decoding and hardware decoding. When using hardware decoding, for different products, the decoding protocols are different and the hardware decoding is only supported by some products.
 */
-(IBAction) onSegmentControlValueChanged:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
    [[VideoPreviewer instance] setDecoderWithProduct:[DemoComponentHelper fetchProduct] andDecoderType:VideoPreviewerDecoderTypeSoftwareDecoder];
    }
    else
    {
        BOOL result = [[VideoPreviewer instance] setDecoderWithProduct:[DemoComponentHelper fetchProduct] andDecoderType:VideoPreviewerDecoderTypeHardwareDecoder];
        if (!result) {
            NSLog(@"Not suitable hardware decoder for the current product. "); 
        }
    }
}

- (IBAction)onThermalTemperatureDataSwitchValueChanged:(id)sender {
    DJICamera* camera = [DemoComponentHelper fetchCamera];
    if (camera) {
        [camera setThermalTemperatureDataEnabled:((UISwitch*)sender).on withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Failed to set the thermal temperature data enabled: %@", error.description);
            }
        }];
    }
}

- (void)updateThermalCameraUI {
    DJICamera* camera = [DemoComponentHelper fetchCamera];
    if (camera && [camera isThermalImagingCamera]) {
        [self.fpvTemView setHidden:NO];
        WeakRef(target);
        [camera getThermalTemperatureDataEnabledWithCompletion:^(BOOL enabled, NSError * _Nullable error) {
            WeakReturn(target);
            if (error) {
                ShowResult(@"Failed to get the Thermal Temperature Data enable status: %@", error.description);
            }
            else {
                [target.fpvTemEnableSwitch setOn:enabled];
            }
        }];
    }
    else {
        [self.fpvTemView setHidden:YES];
    }
}

#pragma mark - DJICameraDelegate
/**
 *  This video data is received through this method. Then the data is passed to VideoPreviewer.
 */
- (void)camera:(DJICamera *)camera didReceiveVideoData:(uint8_t *)videoBuffer length:(size_t)size
{
    uint8_t* pBuffer = (uint8_t*)malloc(size);
    memcpy(pBuffer, videoBuffer, size);
    if(![[[VideoPreviewer instance] dataQueue] isFull]){
        [[VideoPreviewer instance] push:pBuffer length:(int)size];
    }
}

/**
 *  DJICamera will send the live stream only when the mode is in DJICameraModeShootPhoto or DJICameraModeRecordVideo. Therefore, in order 
 *  to demonstrate the FPV (first person view), we need to switch to mode to one of them.
 */
-(void)camera:(DJICamera *)camera didUpdateSystemState:(DJICameraSystemState *)systemState
{
    if (systemState.mode == DJICameraModePlayback ||
        systemState.mode == DJICameraModeMediaDownload) {
        if (self.needToSetMode) {
            self.needToSetMode = NO;
            WeakRef(obj);
            [camera setCameraMode:DJICameraModeShootPhoto withCompletion:^(NSError * _Nullable error) {
                if (error) {
                    WeakReturn(obj);
                    obj.needToSetMode = YES;
                }
            }];
        }
    }
}

-(void)camera:(DJICamera *)camera didUpdateTemperatureData:(float)temperature {
    self.fpvTemperatureData.text = [NSString stringWithFormat:@"%f", temperature];
}

@end
