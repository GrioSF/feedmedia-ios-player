//
//  PlayerViewController.m
//  PlayerInterfaceLibrary
//
//  Created by Giuseppe Barbalinardo on 12/3/14.
//  Copyright (c) 2014 Grio. All rights reserved.
//

#import "PlayerViewController.h"
#import "FMPlayerBigViewController.h"
#import "FMPlayerSmallViewController.h"

@interface PlayerViewController ()
- (IBAction)showWebRadio:(id)sender;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showWebRadio:(id)sender {
    FMPlayerSmallViewController *vc = [FMPlayerSmallViewController new];
    
    // To add the transparent background in iOS 7
    self.modalPresentationStyle = UIModalPresentationCurrentContext;

    [self presentViewController:vc animated:YES completion:nil];
}
@end
