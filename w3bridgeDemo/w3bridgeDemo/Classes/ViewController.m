//
//  ViewController.m
//  w3bridgeDemo
//
//  Created by KH Kim on 2014. 2. 19..
//  Modified by KH Kim on 2015. 2. 10..
//  Copyright (c) 2014년 KH Kim. All rights reserved.
//

#import "ViewController.h"

#define URLOfSample @"http://pisces.jdsn.net/w3bridgeDemo/html/w3bridge-sample-main.html"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.destination = [NSURL URLWithString:URLOfSample];
}

@end
