//
//  ViewController.m
//  FFEditionManager
//
//  Created by fen9fe1 on 2017/5/15.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import "ViewController.h"
#import "NewEditionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NewEditionManager checkNewEditionWithAppID:@"123321123"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
