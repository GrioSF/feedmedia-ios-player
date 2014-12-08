//
//  PlayerViewController.m
//  PlayerInterfaceLibrary
//
//  Created by Giuseppe Barbalinardo on 12/3/14.
//  Copyright (c) 2014 Grio. All rights reserved.
//

#import "PlayerViewController.h"
#import "BigPlayerViewController.h"
#import "SmallPlayerViewController.h"

@interface PlayerViewController ()
- (IBAction)showWebRadio:(id)sender;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showWebRadio:(id)sender {
    SmallPlayerViewController *vc = [SmallPlayerViewController new];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
