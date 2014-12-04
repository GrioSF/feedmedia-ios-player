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

@end
