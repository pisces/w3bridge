//
//  UILayerBridgeWebViewController.h
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

#import "SimpleBridgeWebViewController.h"

typedef struct {
    CGFloat width;
    CGFloat height;
    BOOL modal;
} LayerOption;

LayerOption LayerOptionMake(CGFloat width, CGFloat height, BOOL modal);
BOOL LayerOptionEquals(LayerOption layerOption1, LayerOption layerOption2);

@interface UILayerBridgeWebViewController : SimpleBridgeWebViewController
@property (nonatomic) LayerOption layerOption;
@property (nonatomic, readonly) UIView *modalView;
- (void)showInView:(UIView *)view;
@end