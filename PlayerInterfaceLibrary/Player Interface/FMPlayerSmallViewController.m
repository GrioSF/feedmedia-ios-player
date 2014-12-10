//
//  FMPlayerSmallViewController.m
//  PlayerInterfaceLibrary
//
//  Created by Giuseppe Barbalinardo on 12/4/14.
//  Copyright (c) 2014 Grio. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <FeedMediaSdk/FMAudioPlayer.h>
#import <FeedMediaSdk/FMAudioItem.h>

#import "FMPlayerSmallViewController.h"

@interface FMPlayerSmallViewController ()
@property (strong, nonatomic) FMAudioPlayer *audioPlayer;
@property (strong, nonatomic) FMAudioItem *audioItem;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

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
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
- (IBAction)playButtonTouched:(id)sender;
- (IBAction)skipButtonTouched:(id)sender;
- (IBAction)thumbsUpButtonTouched:(id)sender;
- (IBAction)thumbsDownButtonTouched:(id)sender;
- (IBAction)volumeButtonTouched:(id)sender;
- (IBAction)volumeSliderValueChanged:(id)sender;
- (IBAction)closeButtonTouched:(id)sender;

@end

@implementation FMPlayerSmallViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        _audioPlayer = [FMAudioPlayer sharedPlayer];
        _isMute = NO;
        _userDefaults = [NSUserDefaults standardUserDefaults];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Update player state
    [self updatePlayer];
    if (self.audioPlayer.playbackState == FMAudioPlayerPlaybackStateComplete) {
        [self.audioPlayer play];
    }
    
    // Change default slider appearance
    UIImage *thumbImage = [UIImage imageNamed:@"volume-control-wide"];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];

    // Add timer to update playing info
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updatePlayingInfo)
                                   userInfo:nil
                                    repeats:YES];
    
    // Add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlayer)
                                                 name:FMAudioPlayerPlaybackStateDidChangeNotification
                                               object:self.audioPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showErrorSkip:)
                                                 name:FMAudioPlayerSkipFailedNotification
                                               object:self.audioPlayer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FMAudioPlayerPlaybackStateDidChangeNotification
                                                  object:self.audioPlayer];
}

# pragma mark - controls

- (IBAction)playButtonTouched:(id)sender {
    switch(self.audioPlayer.playbackState) {
        case FMAudioPlayerPlaybackStatePlaying:
            [self.audioPlayer pause];
            break;
        case FMAudioPlayerPlaybackStateReadyToPlay:
        case FMAudioPlayerPlaybackStatePaused:
        case FMAudioPlayerPlaybackStateComplete:
            [self.audioPlayer play];
            break;
        default:
            break;
    }
    [self updatePlayer];
}


- (IBAction)skipButtonTouched:(id)sender {
    [self.audioPlayer skip];
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

- (IBAction)volumeSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self updateVolume:slider.value];
}

- (IBAction)closeButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)muteVolume {
    if (self.volumeSlider.value != 0) {
        [self.userDefaults setFloat:self.volumeSlider.value forKey:@"previousVolumeValue"];
        [self.userDefaults synchronize];
    }
    [self updateVolume:0];
}

- (void)unMuteVolume {
    float previousVolumeValue = [self.userDefaults floatForKey:@"previousVolumeValue"];
    [self updateVolume:previousVolumeValue];
}

# pragma mark - player info

- (void)updatePlayer {
    [self updateVolume:self.audioPlayer.mixVolume];
    [self updatePlayingInfo];
    [self updateTrackInfo];
    
    switch(self.audioPlayer.playbackState) {
        case FMAudioPlayerPlaybackStatePlaying:
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            self.skipButton.alpha = 1;
            self.playButton.alpha = 1;
            break;
        case FMAudioPlayerPlaybackStateWaitingForItem:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.playButton.alpha = 0.25;
            self.skipButton.alpha = 0.25;
            self.timeElapsedLabel.text = @"0:00";
            self.totalTimeLabel.text = @"-:--";
            [self resetLikeDislikeAppearance];
            break;
        case FMAudioPlayerPlaybackStateReadyToPlay:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.skipButton.alpha = 1;
            self.playButton.alpha = 1;
            [self resetLikeDislikeAppearance];
            break;
        case FMAudioPlayerPlaybackStatePaused:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.skipButton.alpha = 1;
            self.playButton.alpha = 1;
            break;
        case FMAudioPlayerPlaybackStateStalled:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.playButton.alpha = 0.25;
            self.skipButton.alpha = 0.25;
            break;
        case FMAudioPlayerPlaybackStateRequestingSkip:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.playButton.alpha = 1;
            self.skipButton.alpha = 0.25;
            self.timeElapsedLabel.text = @"0:00";
            self.totalTimeLabel.text = @"-:--";
            break;
        case FMAudioPlayerPlaybackStateComplete:
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            self.playButton.alpha = 1;
            self.skipButton.alpha = 1;
            self.timeElapsedLabel.text = @"";
            self.totalTimeLabel.text = @"";
            self.skipButton.alpha = 0.25;
            break;
        default:
            break;
    }
    [self updateLikeButtons];
}

- (void)updatePlayingInfo {
    float progress = self.audioPlayer.currentPlaybackTime / self.audioPlayer.currentItemDuration;
    self.progressIndicator.progress = progress;
    long currentTime = lroundf(self.audioPlayer.currentPlaybackTime);
    self.timeElapsedLabel.text = [NSString stringWithFormat:@"%ld:%02ld", currentTime / 60, currentTime % 60];
    if (currentTime < 0) {
        self.timeElapsedLabel.text = @"0:00";
    }
    long trackLength = lroundf(self.audioItem.duration);
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld", trackLength / 60, trackLength % 60];
    if ((self.audioPlayer.playbackState == FMAudioPlayerPlaybackStateComplete)) {
        self.timeElapsedLabel.text = @"";
        self.totalTimeLabel.text = @"";
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
}

# pragma mark - like and dislike

- (void)resetLikeDislikeAppearance {
    [self setItemLiked:NO];
    [self setItemDisliked:NO];
    self.thumbsUpButton.alpha = 0.25;
    self.thumbsDownButton.alpha = 0.25;
}

- (void)updateLikeButtons {
    if ([self isItemLiked]) {
        self.thumbsUpButton.alpha = 1;
    } else {
        self.thumbsUpButton.alpha = 0.25;
    }
    if ([self isItemDisliked]) {
        self.thumbsDownButton.alpha = 1;
    } else {
        self.thumbsDownButton.alpha = 0.25;
    }
}

- (IBAction)thumbsUpButtonTouched:(id)sender {
    if ([self isItemLiked]){
        [self.audioPlayer unlike];
        [self setItemLiked:NO];
    } else {
        [self.audioPlayer like];
        [self setItemLiked:YES];
        [self setItemDisliked:NO];
    }
    [self updateLikeButtons];
}

- (IBAction)thumbsDownButtonTouched:(id)sender {
    if ([self isItemDisliked]){
        [self.audioPlayer unDislike];
        [self setItemDisliked: NO];
    } else {
        [self.audioPlayer dislike];
        [self setItemDisliked:YES];
        [self setItemLiked:NO];
    }
    [self updateLikeButtons];
}

- (BOOL)isItemLiked {
    return [self.userDefaults boolForKey:@"isItemLiked"];
}

- (void)setItemLiked:(BOOL)value {
    [self.userDefaults setBool:value forKey:@"isItemLiked"];
    [self.userDefaults synchronize];
}

- (BOOL)isItemDisliked {
    return [self.userDefaults boolForKey:@"isItemDisliked"];
}

- (void)setItemDisliked:(BOOL)value {
    [self.userDefaults setBool:value forKey:@"isItemDisliked"];
    [self.userDefaults synchronize];
}

# pragma mark - helper methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showErrorSkip:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSError *error = (NSError *)dict[FMAudioPlayerSkipFailureErrorKey];
    self.errorLabel.text = [error localizedDescription];
    double delayInSeconds = .8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.errorLabel.text = @"";
    });
}

@end
