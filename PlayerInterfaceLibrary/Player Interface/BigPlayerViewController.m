//
//  BigPlayerViewController.m
//  PlayerInterfaceLibrary
//
//  Created by Giuseppe Barbalinardo on 12/4/14.
//  Copyright (c) 2014 Grio. All rights reserved.
//

#import "BigPlayerViewController.h"
#import "FMAudioPlayer.h"

@interface BigPlayerViewController ()
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FMAudioPlayer sharedPlayer] play];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)playButtonTouched:(id)sender {
}

- (IBAction)skipButtonTouched:(id)sender {
}

- (IBAction)thumbsUpButtonTouched:(id)sender {
}

- (IBAction)thumbsDownButtonTouched:(id)sender {
}

- (IBAction)volumeButtonTouched:(id)sender {
}

- (IBAction)volumeSliderValueChanged:(id)sender {
}

- (IBAction)closeButtonTouched:(id)sender {
}
@end
