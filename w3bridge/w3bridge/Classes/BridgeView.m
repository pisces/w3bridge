//
//  BridgeWeb.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 13..
//      "addRightBarButtonItem" method added
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

#import "BridgeView.h"

// ================================================================================================
//
//  Implementation: BridgeView
//
// ================================================================================================

@implementation BridgeView
{
@private
    BridgeViewOption *bridgeViewOption;
}

// ================================================================================================
//  Overridden: CDVPlugin
// ================================================================================================

#pragma mark - Overridden: CDVPlugin

- (void)dealloc
{
    bridgeViewOption = nil;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)addRightBarButtonItem:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *text = [[arguments objectAtIndex:1] JSStringValue];
    NSString *imageName = [[arguments objectAtIndex:2] JSStringValue];
    NSString *callbackFunctionName = [[arguments objectAtIndex:3] JSStringValue];
    UIBridgeWebViewController *controller = (UIBridgeWebViewController *) self.viewController;
    
    [controller addRightBarButtonItemWithText:text imageName:imageName callbackFunctionName:callbackFunctionName];
}

- (void)close:(NSArray *)arguments withDict:(NSMutableDictionary*)options
{
    BOOL animated = arguments.count > 1 ? [[arguments objectAtIndex:1] boolValue] : YES;
    [self.viewController closeAnimated:animated];
}

- (void)hideActivityIndicatorView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    UIBridgeWebViewController *bridgeController = (UIBridgeWebViewController *) self.viewController;
    [ActivityIndicatorManager deactivate:bridgeController.scrollViewOnWebView];
}

- (void)openBrowser:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (arguments.count > 1)
    {
        NSURL *url = [NSURL URLWithString:[[arguments objectAtIndex:1] JSStringValue]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)openLayerBridgeWebView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (arguments.count > 1)
    {
        CGFloat width = [[options objectForKey:@"width"] floatValue];
        CGFloat height = [[options objectForKey:@"height"] floatValue];
        BOOL modal = [[options objectForKey:@"height"] boolValue];
        
        UIBridgeWebViewController *bridgeController = (UIBridgeWebViewController *) self.viewController;
        [bridgeController openLayerBridgeWebViewWithURL:[arguments objectAtIndex:1] layerOption:LayerOptionMake(width, height, modal)];
    }
}

- (void)popWithURL:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    UIBridgeWebViewController *bridgeController = [[UIBridgeWebViewController alloc] init];
    bridgeController.leftBarButtonItemType = LeftBarButtonItemTypeClose;
    bridgeViewOption = [BridgeViewOption optionWithArguments:arguments withViewController:bridgeController viewType:BridgeViewTypePop];
    
    [self setPropertiesWithViewController:bridgeController];
    [self popUpWithNavigation:bridgeController modalTransitionStyle:bridgeViewOption.modalTransitionStyle];
    
    bridgeController.destination = bridgeViewOption.destination;
}

- (void)popToRootView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    BOOL animated = arguments.count > 1 ? [[arguments objectAtIndex:1] boolValue] : YES;
    [self.viewController.navigationController popToRootViewControllerAnimated:animated];
}

- (void)pushWithURL:(NSArray *)arguments withDict:(NSMutableDictionary*)options
{
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    if (controller.navigationController)
    {
        if ([controller isKindOfClass:[SimpleBridgeWebViewController class]])
            ((SimpleBridgeWebViewController *) controller).viewPushed = YES;
        
        UIBridgeWebViewController *nextController = [[UIBridgeWebViewController alloc] init];
        bridgeViewOption = [BridgeViewOption optionWithArguments:arguments withViewController:nextController viewType:BridgeViewTypePush];
        nextController.hidesBottomBarWhenPushed = bridgeViewOption.hidesBottomBarWhenPushed;
        nextController.leftBarButtonItemType = LeftBarButtonItemTypeCustom;
        
        [self setPropertiesWithViewController:nextController];
        [controller.navigationController pushViewController:nextController animated:YES];
        
        nextController.destination = bridgeViewOption.destination;
    }
}

- (void)setProperty:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    for (NSString *name in options)
    {
        NSString *key = [name isEqualToString:@"landscape"] ? @"interfaceOrientationState" : name;
        [self.viewController setValue:[options objectForKey:name] forKey:key];
    }
}

- (void)setSize:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (arguments.count > 2)
    {
        CGFloat width = [[arguments objectAtIndex:1] floatValue];
        CGFloat height = [[arguments objectAtIndex:2] floatValue];
        CGRect viewFrame = self.viewController.view.frame;
        viewFrame.size.width = width;
        viewFrame.size.height = height;
        self.viewController.view.frame = viewFrame;
        [[NSNotificationCenter defaultCenter] postNotificationName:bridgeViewFrameSizeChangedNotification object:self.viewController];
    }
}

- (void)setTitle:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.viewController.title = [[arguments objectAtIndex:1] JSStringValue];
}

- (void)showActivityIndicatorView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    UIBridgeWebViewController *bridgeController = (UIBridgeWebViewController *) self.viewController;
    [ActivityIndicatorManager activate:bridgeController.scrollViewOnWebView modal:NO];
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)popUpWithNavigation:(UIViewController *)targetController modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle
{
    UINavigationController *navigationController = [[PSNavigationController alloc] initWithRootViewController:targetController];
    navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    navigationController.modalTransitionStyle = modalTransitionStyle;
    
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    
    if (controller.modalViewController)
        [controller.modalViewController presentModalViewController:navigationController animated:NO];
    else
        [controller presentModalViewController:navigationController animated:YES];
}

- (void)setPropertiesWithViewController:(UIBridgeWebViewController *)viewController
{
    if (bridgeViewOption)
    {
        viewController.closeEnabled = bridgeViewOption.closeEnabled;
        viewController.refreshEnabled = bridgeViewOption.refreshEnabled;
        viewController.interfaceOrientationState = bridgeViewOption.interfaceOrientationState;
        viewController.leftBarButtonItemText = bridgeViewOption.leftBarButtonItemText;
        viewController.scrollEnabled = bridgeViewOption.scrollEnabled;
        viewController.title = bridgeViewOption.title;
    }
}
@end

// ================================================================================================
//
//  Implementation: BridgeViewOption
//
// ================================================================================================

#pragma mark - Class methods

@implementation BridgeViewOption
+ (BridgeViewOption *)optionWithArguments:(NSArray *)arguments withViewController:(UIBridgeWebViewController *)viewController viewType:(BridgeViewType)viewType
{
    BridgeViewOption *option = [[BridgeViewOption alloc] init];
    
    option.closeEnabled = arguments.count > 8 ? [[arguments objectAtIndex:8] boolValue] : YES;
    option.refreshEnabled = arguments.count > 7 ? [[arguments objectAtIndex:7] boolValue] : viewController.refreshEnabled;
    option.title = arguments.count > 6 ? [[arguments objectAtIndex:6] JSStringValue] : nil;
    option.scrollEnabled = arguments.count > 2 ? [[arguments objectAtIndex:2] boolValue] : viewController.scrollEnabled;
    option.destination = arguments.count > 1 ? [NSURL URLWithString:[[arguments objectAtIndex:1] JSStringValue]] : nil;
    
    if (viewType == BridgeViewTypePush)
    {
        option.leftBarButtonItemText = arguments.count > 5 ? [[arguments objectAtIndex:5] JSStringValue] : nil;
        option.interfaceOrientationState = arguments.count > 4 ? [[arguments objectAtIndex:4] intValue] : viewController.interfaceOrientationState;
        option.hidesBottomBarWhenPushed = arguments.count > 3 ? [[arguments objectAtIndex:3] boolValue] : viewController.hidesBottomBarWhenPushed;
    }
    else if (viewType == BridgeViewTypePop)
    {
        option.modalTransitionStyle = arguments.count > 5 ? [[arguments objectAtIndex:5] intValue] : UIModalTransitionStyleCoverVertical;
        option.leftBarButtonItemText = arguments.count > 4 ? [[arguments objectAtIndex:4] JSStringValue] : nil;
        option.interfaceOrientationState = arguments.count > 3 ? [[arguments objectAtIndex:3] intValue] : viewController.interfaceOrientationState;
    }
    
    return option;
}

// ================================================================================================
//  Overridden: NSObject
// ================================================================================================

- (void)dealloc
{
    _destination = nil;
    _leftBarButtonItemText = nil;
    _title = nil;
}
@end