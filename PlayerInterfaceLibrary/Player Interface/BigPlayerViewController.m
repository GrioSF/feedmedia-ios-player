//
//  BigPlayerViewController.m
//  PlayerInterfaceLibrary
//
//  Created by Giuseppe Barbalinardo on 12/4/14.
//  Copyright (c) 2014 Grio. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "BigPlayerViewController.h"
#import "FMAudioPlayer.h"
#import "FMAudioItem.h"

@interface BigPlayerViewController ()
@property (strong, nonatomic) FMAudioPlayer *audioPlayer;

@property (nonatomic) float previousVolumeValue;
@property (nonatomic) BOOL isMute;

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbsDownButton;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
- (IBAction)playButtonTouched:(id)sender;
- (IBAction)skipButtonTouched:(id)sender;
- (IBAction)thumbsUpButtonTouched:(id)sender;
- (IBAction)thumbsDownButtonTouched:(id)sender;
- (IBAction)volumeButtonTouched:(id)sender;
- (IBAction)volumeSliderValueChanged:(id)sender;
- (IBAction)closeButtonTouched:(id)sender;


@end

@implementation BigPlayerViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        _audioPlayer = [FMAudioPlayer sharedPlayer];
        _isMute = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerActiveStationDidChangeNotification object:self.audioPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerCurrentItemDidChangeNotification object:self.audioPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerPlaybackStateDidChangeNotification object:self.audioPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerSkipFailedNotification object:self.audioPlayer];
}

- (IBAction)playButtonTouched:(id)sender {
    [self.audioPlayer play];
//    [self updateTrackInfo];
    [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

- (IBAction)skipButtonTouched:(id)sender {
    [[FMAudioPlayer sharedPlayer] skip];
}

- (IBAction)thumbsUpButtonTouched:(id)sender {
}

- (IBAction)thumbsDownButtonTouched:(id)sender {
}

- (IBAction)volumeButtonTouched:(id)sender {
    if (self.isMute) {
        [self updateVolume:self.previousVolumeValue];
    } else {
        if (self.volumeSlider.value != 0) {
            self.previousVolumeValue = self.volumeSlider.value;
        }
        [self updateVolume:0];
    }
}

- (IBAction)volumeSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self updateVolume:slider.value];
}

- (void)updateVolume:(float)volumeValue {
    self.volumeSlider.value = volumeValue;
    NSString *imageName;
    if (volumeValue == 0) {
        imageName = @"volume-mute";
    } else if (volumeValue < .5) {
        imageName = @"volume-low";
    } else if (volumeValue < 1) {
        imageName = @"volume-medium";
    } else {
        imageName = @"volume-high";
    }
    [self.volumeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.isMute = (volumeValue == 0);
    [[FMAudioPlayer sharedPlayer] setMixVolume:volumeValue];
}

- (void)updateTrackInfo {
    FMAudioItem *audioItem = [self.audioPlayer currentItem];
    self.artistLabel.text = audioItem.artist;
    self.titleLabel.text = audioItem.name;
    self.albumLabel.text = audioItem.album;
//    [self.view setNeedsDisplay];
}

- (IBAction)closeButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
