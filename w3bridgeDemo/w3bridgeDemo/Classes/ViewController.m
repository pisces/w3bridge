//
//  ViewController.m
//  w3bridgeDemo
//
//  Created by KH Kim on 2014. 2. 19..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
//

#import "ViewController.h"

#define URLOfSample @"https://raw.github.com/pisces/w3bridge/master/w3bridgeDemo/www/html/w3bridge-sample-main.html"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.destination = [NSURL URLWithString:URLOfSample];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
