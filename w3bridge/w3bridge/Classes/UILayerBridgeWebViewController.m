//
//  UILayerBridgeWebViewController.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 11..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 ~ 2015 KH Kim
 
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
//
//  Implementation: UILayerPopUpBridgeWebViewController
//
// ================================================================================================

@implementation UILayerBridgeWebViewController
{
@private
    BOOL layerOptionChanged;
    UITapGestureRecognizer *viewGestureRecognizer;
    UIView *targetView;
}

// ================================================================================================
//  Overridden: SimpleBridgeWebViewController
// ================================================================================================

#pragma mark - Overridden: SimpleBridgeWebViewController

- (void)commitProperties
{
    [super commitProperties];
    
    if (layerOptionChanged)
    {
        layerOptionChanged = NO;
        
        [self layoutSubviews];
    }
}

- (void)clear
{
    [super clear];
    
    [self.modalView removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self removeViewGestureRecognizer];
}

- (void)dealloc
{
}

- (void)layoutSubviews
{
    self.view.frame = CGRectMake((targetView.width - self.layerOption.width)/2, (targetView.height - self.layerOption.height)/2, self.layerOption.width, self.layerOption.height);
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setLayerOption:(LayerOption)layerOption
{
    if (LayerOptionEquals(layerOption, _layerOption))
        return;
    
    _layerOption = layerOption;
    layerOptionChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)showInView:(UIView *)view
{
    if (targetView)
        return;
    
    targetView = view;
    
    if (targetView)
    {
        if (self.layerOption.modal)
        {
            _modalView = [[UIView alloc] init];
            _modalView.alpha = 0;
            _modalView.autoresizingMask = UIViewAutoresizingFlexibleAll;
            _modalView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            _modalView.frame = targetView.bounds;
            
            viewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
            
            [targetView addSubview:self.modalView];
            [self.modalView addGestureRecognizer:viewGestureRecognizer];
        }
        
        self.view.alpha = 0;
        
        [targetView addSubview:self.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:animationOptions animations:^(void){
            self.modalView.alpha = 1;
            self.view.alpha = 1;
        } completion:^(BOOL finished){
        }];
    }
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)removeViewGestureRecognizer
{
    [self.modalView removeGestureRecognizer:viewGestureRecognizer];
    [viewGestureRecognizer removeTarget:self action:@selector(viewTapped)];
    
    viewGestureRecognizer = nil;
}

#pragma mark - UITapGestureRecognizer selector

- (void)viewTapped
{
    [self closeAnimated:NO];
}

@end
