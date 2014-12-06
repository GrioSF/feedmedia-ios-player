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
@property (strong, nonatomic) FMAudioItem *audioItem;

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
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
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
    // Update current status
    [self updateVolume:self.audioPlayer.mixVolume];
    [self updatePlayButton];
    [self updatePlayingInfo];
    [self updateTrackInfo];
    
    // Change default slider appearance
    UIImage *thumbImage = [UIImage imageNamed:@"volume-control-wide"];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];

    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updatePlayingInfo)
                                   userInfo:nil
                                    repeats:YES];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerActiveStationDidChangeNotification object:self.audioPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerCurrentItemDidChangeNotification object:self.audioPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testMethod) name:FMAudioPlayerPlaybackStateDidChangeNotification object:self.audioPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackInfo) name:FMAudioPlayerSkipFailedNotification object:self.audioPlayer];
}

- (void)testMethod {
    
}

- (IBAction)playButtonTouched:(id)sender {
    [self updatePlayButton];
    switch(self.audioPlayer.playbackState) {
        case FMAudioPlayerPlaybackStatePlaying:
            [self.audioPlayer pause];
            break;
        default:
            [self.audioPlayer play];
            break;
    }
    [self updateTrackInfo];
}


- (IBAction)skipButtonTouched:(id)sender {
    [self.audioPlayer skip];
}

- (IBAction)thumbsUpButtonTouched:(id)sender {
}

- (IBAction)thumbsDownButtonTouched:(id)sender {
}

- (IBAction)volumeButtonTouched:(id)sender {
    if (self.isMute) {
        [self unMuteVolume];
        self.isMute = NO;
    } else {
        [self muteVolume];
        self.isMute = YES;
    }
}

- (void)muteVolume {
    if (self.volumeSlider.value != 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.volumeSlider.value forKey:@"previousVolumeValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self updateVolume:0];
}

- (void)unMuteVolume {
    float previousVolumeValue = [[NSUserDefaults standardUserDefaults] floatForKey:@"previousVolumeValue"];
    [self updateVolume:previousVolumeValue];
}

- (IBAction)volumeSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self updateVolume:slider.value];
}

- (void)updatePlayingInfo {
    float progress = self.audioPlayer.currentPlaybackTime / self.audioPlayer.currentItemDuration;
    self.progressIndicator.progress = progress;
    long currentTime = lroundf(self.audioPlayer.currentPlaybackTime);
    self.timeElapsedLabel.text = [NSString stringWithFormat:@"%ld:%02ld", currentTime / 60, currentTime % 60];
}

- (void) updatePlayButton {
    switch(self.audioPlayer.playbackState) {
        case FMAudioPlayerPlaybackStatePlaying:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
        default:
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            break;
    }
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
    self.audioItem = [self.audioPlayer currentItem];
    self.artistLabel.text = self.audioItem.artist;
    self.titleLabel.text = self.audioItem.name;
    self.albumLabel.text = self.audioItem.album;
    long trackLength = lroundf(self.audioItem.duration);
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld", trackLength / 60, trackLength % 60];
}

- (IBAction)closeButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
