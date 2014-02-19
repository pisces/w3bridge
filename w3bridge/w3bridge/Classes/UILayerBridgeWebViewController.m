//
//  UILayerBridgeWebViewController.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 KH Kim
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "UILayerBridgeWebViewController.h"

LayerOption LayerOptionMake(CGFloat width, CGFloat height, BOOL modal)
{
    LayerOption option = {
        .width = width,
        .height = height,
        .modal = modal
    };
    return option;
}

BOOL LayerOptionEquals(LayerOption layerOption1, LayerOption layerOption2)
{
    return layerOption1.width == layerOption2.width && layerOption1.height == layerOption2.height && layerOption1.modal && layerOption2.modal;
}

// ================================================================================================
//  UILayerPopUpBridgeWebViewController Implementation
// ================================================================================================

@implementation UILayerBridgeWebViewController
{
@private
    BOOL layerOptionChanged;
    BOOL viewAppeared;
    UITapGestureRecognizer *viewGestureRecognizer;
    UIView *targetView;
}

// ================================================================================================
//  View Cycle
// ================================================================================================

- (void)dealloc
{
    [self viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView removeFromSuperview];
    
    self.view = self.webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    viewAppeared = YES;
    
    [self layoutView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    viewAppeared = NO;
}

- (void)viewDidUnload
{
    [self removeSelf];
    
    [super viewDidUnload];
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
    
    [self removeSelf];
}

- (void)setLayerOption:(LayerOption)layerOption
{
    if (LayerOptionEquals(layerOption, _layerOption))
        return;
    
    _layerOption = layerOption;
    layerOptionChanged = YES;
    
    [self layerOptionChanged];
}

- (void)showInView:(UIView *)view
{
    if (targetView)
        return;
    
    targetView = view;
    
    if (targetView)
    {
        if (_layerOption.modal)
        {
            _modalView = [[UIView alloc] init];
            _modalView.alpha = 0;
            _modalView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            _modalView.frame = CGRectMake(0, 0, targetView.frame.size.width, targetView.frame.size.height);
            viewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
            
            [view addSubview:_modalView];
            [_modalView addGestureRecognizer:viewGestureRecognizer];
        }
        
        self.view.alpha = 0;
        
        [self layoutView];
        [view addSubview:self.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:7 << 16 animations:^(void){
            _modalView.alpha = 1;
            self.view.alpha = 1;
        } completion:^(BOOL finished){
        }];
    }
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)layerOptionChanged
{
    if (viewAppeared && layerOptionChanged)
    {
        layerOptionChanged = NO;
        
        [self layoutView];
    }
}

- (void)layoutView
{
    self.view.frame = CGRectMake((targetView.frame.size.width - _layerOption.width)/2, (targetView.frame.size.height - _layerOption.height)/2, _layerOption.width, _layerOption.height);
}

- (void)removeSelf
{
    [_modalView removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeViewGestureRecognizer];
    
    targetView = nil;
    _modalView = nil;
}

- (void)removeViewGestureRecognizer
{
    [_modalView removeGestureRecognizer:viewGestureRecognizer];
    [viewGestureRecognizer removeTarget:self action:@selector(viewTapped)];
    viewGestureRecognizer = nil;
}

// ================================================================================================
//  Selector
// ================================================================================================

- (void)viewTapped
{
    [self dismissModalViewControllerAnimated:NO];
}
@end
