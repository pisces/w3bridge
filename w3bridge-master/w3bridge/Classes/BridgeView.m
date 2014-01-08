//
//  BridgeWeb.m
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

#import "BridgeView.h"

@implementation BridgeView

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

- (void)popWithURL:(NSArray *)arguments withDict:(NSMutableDictionary*)options
{
    UIBridgeWebViewController *bridgeController = [[[UIBridgeWebViewController alloc] init] autorelease];
    
    if (arguments.count > 7)
        bridgeController.refreshEnabled = [[arguments objectAtIndex:7] boolValue];
    
    NSString *title = arguments.count > 6 ? [[arguments objectAtIndex:6] JSStringValue] : nil;
    bridgeController.title = title;
    
    UIModalTransitionStyle modalTransitionStyle = arguments.count > 5 ? [[arguments objectAtIndex:5] intValue] : UIModalTransitionStyleCoverVertical;
    
    NSString *leftBarButtonItemText = arguments.count > 4 ? [[arguments objectAtIndex:4] JSStringValue] : nil;
    
    if (!leftBarButtonItemText || ![leftBarButtonItemText isEqualToString:@"none"])
    {
        UIBarButtonItem *leftBarButtonItem = leftBarButtonItemText ? [[UIApplication sharedApplication].theme leftBarButtonItemWithTitle:leftBarButtonItemText target:self action:@selector(dissmissModalViewController:)] : [self createCommonBarItem];
        [bridgeController.navigationItem addLeftBarButtonItem:leftBarButtonItem];
    }
    
    if (arguments.count > 3)
        bridgeController.interfaceOrientationState = [[arguments objectAtIndex:3] intValue];
    
    if (arguments.count > 2)
        bridgeController.scrollEnabled = [[arguments objectAtIndex:2] boolValue];
    
    [self popUpWithNavigation:bridgeController modalTransitionStyle:modalTransitionStyle];
    
    if (arguments.count > 1)
        bridgeController.destination = [NSURL URLWithString:[[arguments objectAtIndex:1] JSStringValue]];
}

- (void)popToRootView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    BOOL animated = arguments.count > 1 ? [[arguments objectAtIndex:1] boolValue] : YES;
    [self.viewController.navigationController popToRootViewControllerAnimated:animated];
}

- (void)pushWithURL:(NSArray *)arguments withDict:(NSMutableDictionary*)options
{
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    if (controller.navigationController != nil)
    {
        UIBridgeWebViewController *nextController = [[[UIBridgeWebViewController alloc] init] autorelease];
        nextController.title = controller.navigationController.visibleViewController.navigationItem.title;
        
        if (arguments.count > 7)
            nextController.refreshEnabled = [[arguments objectAtIndex:7] boolValue];
        
        if ([controller isKindOfClass:[SimpleBridgeWebViewController class]])
            ((SimpleBridgeWebViewController *) controller).viewPushed = YES;
        
        NSString *title = arguments.count > 6 ? [[arguments objectAtIndex:6] JSStringValue] : nil;
        nextController.title = title;
        
        NSString *leftBarButtonItemText = arguments.count > 5 ? [[arguments objectAtIndex:5] JSStringValue] : nil;
        if (leftBarButtonItemText)
        {
            UIBarButtonItem *leftBarButtonItem = [[UIApplication sharedApplication].theme backBarButtonItemWithTitle:leftBarButtonItemText target:self action:@selector(popViewController:)];
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
                nextController.navigationController.navigationBar.topItem.backBarButtonItem = leftBarButtonItem;
            else
                [nextController.navigationItem addLeftBarButtonItem:leftBarButtonItem];
        }
        
        if (arguments.count > 4)
            nextController.interfaceOrientationState = [[arguments objectAtIndex:4] boolValue];
        
        if (arguments.count > 3)
            nextController.hidesBottomBarWhenPushed = [[arguments objectAtIndex:3] boolValue];
        
        if (arguments.count > 2)
            nextController.scrollEnabled = [[arguments objectAtIndex:2] boolValue];
        
        [controller.navigationController pushViewController:nextController animated:YES];
        
        if (arguments.count > 1)
            nextController.destination = [NSURL URLWithString:[[arguments objectAtIndex:1] JSStringValue]];
    }
}

- (void)showActivityIndicatorView:(NSArray *)arguments withDict:(NSMutableDictionary *)options
{
    UIBridgeWebViewController *bridgeController = (UIBridgeWebViewController *) self.viewController;
    [ActivityIndicatorManager activate:bridgeController.scrollViewOnWebView modal:NO];
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

- (UIBarButtonItem *)createCommonBarItem
{
    return [[UIApplication sharedApplication].theme homeBarButtonItemWithTarget:self action:@selector(dissmissModalViewController:)];
}

- (void)dissmissModalViewController:(id)sender
{
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)popViewController:(id)sender
{
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)popUpWithNavigation:(UIViewController *)targetController modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle
{
    UINavigationController *navigationController = [[[PSUINavigationController alloc] initWithRootViewController:targetController] autorelease];
    navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    navigationController.modalTransitionStyle = modalTransitionStyle;
    
    UIViewController *controller = self.viewController.relativeController ? self.viewController.relativeController : self.viewController;
    
    if (controller.modalViewController)
        [controller.modalViewController presentViewController:navigationController animated:NO completion:nil];
    else
        [controller presentViewController:navigationController animated:YES completion:nil];
}
@end