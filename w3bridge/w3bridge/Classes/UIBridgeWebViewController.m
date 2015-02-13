//
//  UIBridgeViewController.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Modified by KH Kim on 2015. 2. 9..
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

#import "UIBridgeWebViewController.h"
#import "w3bridge.h"

NSString *const didClickLeftBarButtonItemNotification = @"didClickLeftBarButtonItemNotification";
NSString *const didClickRightBarButtonItemNotification = @"didClickRightBarButtonItemNotification";
NSString *const shouldAutorotateNotification = @"shouldAutorotateNotification";
NSString *const viewDidAppearNotification = @"viewDidAppearNotification";
NSString *const viewDidDisappearNotification = @"viewDidDisappearNotification";
NSString *const viewWillAppearNotification = @"viewWillAppearNotification";
NSString *const viewWillDisappearNotification = @"viewWillDisappearNotification";

// ================================================================================================
//
//  Implementation: UIBridgeWebViewController
//
// ================================================================================================

@implementation UIBridgeWebViewController
{
@private
    BOOL refreshEnabledChanged;
    BOOL refreshing;
    NSMutableDictionary *barButtonItemHandlerObjectDic;
}

// ================================================================================================
//  Overridden: SimpleBridgeWebViewController
// ================================================================================================

#pragma mark - Overridden: SimpleBridgeWebViewController

- (BOOL)canReceiveNotificationSelfOnly:(NSString *)name
{
    return [name isEqualToString:shouldAutorotateNotification] || [name isEqualToString:viewDidAppearNotification] ||
    [name isEqualToString:viewDidDisappearNotification] || [name isEqualToString:viewWillAppearNotification] ||
    [name isEqualToString:viewWillDisappearNotification] || [name isEqualToString:willCloseViewNotification] ||
    [name isEqualToString:didClickLeftBarButtonItemNotification] || [name isEqualToString:didClickRightBarButtonItemNotification];
}

- (void)clear
{
    [super clear];
    
    [self.refreshControl removeTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem removeLeftBarButtonItem];
    [self.navigationItem removeRightBarButtonItem];
    [barButtonItemHandlerObjectDic removeAllObjects];
}

- (void)commitProperties
{
    [super commitProperties];
    
    if (self.refreshEnabled)
    {
        refreshEnabledChanged = NO;
        self.refreshControl.enabled = self.refreshEnabled;
    }
}

- (BOOL)hidesBottomBarWhenPushed
{
    return _hidesBottomBarWhenPushed;
}

- (void)initProperties
{
    [super initProperties];
    
    self.reloadable = NO;
    self.refreshEnabled = YES;
    self.navigationTheme = [[UIThemeBase alloc] init];
    barButtonItemHandlerObjectDic = [NSMutableDictionary dictionary];
    _hidesBottomBarWhenPushed = NO;
    _closeEnabled = YES;
    _showModalWhenFirstLoading = YES;
    _useDocumentTitle = YES;
    _leftBarButtonItemType = LeftBarButtonItemTypeNone;
}

- (void)loadView
{   
    [super loadView];
    
    if (self.useDocumentTitle)
        self.title = nil;
    
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.scrollViewOnWebView addSubview:self.refreshControl];
    [self setLeftBarButtonItem];
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (!self.closeEnabled)
        [[NSNotificationCenter defaultCenter] postNotificationName:didClickLeftBarButtonItemNotification object:self];
    
    return self.isFirstLoad ? YES : self.closeEnabled;
}

- (void)setLeftBarButtonItem
{
    if ([self.navigationController respondsToSelector:@selector(previousTitle)] && self.navigationController.previousTitle)
    {
        [self setBackBarButtonItemWithTitle:self.leftBarButtonItemText ? self.leftBarButtonItemText : @"" withTheme:self.navigationTheme];
    }
    else if (self.navigationTheme && self.leftBarButtonItemType != LeftBarButtonItemTypeNone)
    {
        UIBarButtonItem *otherItem;
        
        if (self.leftBarButtonItemType == LeftBarButtonItemTypeHome)
            otherItem = [self.navigationTheme homeBarButtonItemWithTarget:self action:@selector(leftBarButtonItemClicked)];
        else if (self.leftBarButtonItemType == LeftBarButtonItemTypeClose)
            otherItem = [self.navigationTheme closeBarButtonItemWithTarget:self action:@selector(leftBarButtonItemClicked)];
        else if (self.leftBarButtonItemType == LeftBarButtonItemTypeCustom)
            otherItem = [self.navigationTheme leftBarButtonItemWithTitle:_leftBarButtonItemText target:self action:@selector(leftBarButtonItemClicked)];
        
        [self.navigationItem addLeftBarButtonItem:otherItem];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:viewWillAppearNotification object:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController customize];
    [self updateBarButtonItems:self.interfaceOrientation];
    [[NSNotificationCenter defaultCenter] postNotificationName:viewDidAppearNotification object:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:viewWillDisappearNotification object:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [ActivityIndicatorManager deactivate:self.scrollViewOnWebView];
    [[NSNotificationCenter defaultCenter] postNotificationName:viewDidDisappearNotification object:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@(interfaceOrientation) forKey:@"interfaceOrientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:shouldAutorotateNotification object:self userInfo:userInfo];
    
    if (self.interfaceOrientationState == 1)
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    else if (self.interfaceOrientationState == 2)
        return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.interfaceOrientationState == 1)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    if (self.interfaceOrientationState == 2)
        return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.interfaceOrientation] forKey:@"interfaceOrientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:shouldAutorotateNotification object:self userInfo:userInfo];
    return self.interfaceOrientationState > 0;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.interfaceOrientationState == 1)
        return self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? UIInterfaceOrientationPortrait : self.interfaceOrientation;
    
    if (self.interfaceOrientationState == 2)
    {
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
            return UIInterfaceOrientationLandscapeRight;
        if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
            return UIInterfaceOrientationLandscapeLeft;
        return self.interfaceOrientation;
    }
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.navigationController customize:toInterfaceOrientation];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [super webViewDidStartLoad:theWebView];
    
    if (refreshing)
        return;
    
    if (self.isFirstLoad && self.showModalWhenFirstLoading)
    {
        [ActivityIndicatorManager activate:self.scrollViewOnWebView message:[w3bridge localizedStringWithKey:@"loading"] modal:YES];
        [ActivityIndicatorManager layout:self.scrollViewOnWebView layoutStyle:ActivityIndicatorLayoutStyleTop];
    }
    else
    {
        [ActivityIndicatorManager activate:self.scrollViewOnWebView modal:NO];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [super webViewDidFinishLoad:theWebView];
    
    [self.refreshControl endRefreshing];
    [ActivityIndicatorManager deactivate:self.scrollViewOnWebView];
    
    NSString *title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.useDocumentTitle && title.hasValue)
        self.title = title;
    
    refreshing = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError*)error
{
    [super webView:webView didFailLoadWithError:error];
    
    [self.refreshControl endRefreshing];
    [ActivityIndicatorManager deactivate:self.scrollViewOnWebView];
    
    refreshing = NO;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setRefreshEnabled:(BOOL)refreshEnabled
{
    if (refreshEnabled == _refreshEnabled)
        return;
    
    _refreshEnabled = refreshEnabled;
    refreshEnabledChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)addRightBarButtonItemWithText:(NSString *)text imageName:(NSString *)imageName callbackFunctionName:(NSString *)callbackFunctionName
{
    UIBarButtonItem *rightBarButtonItem = [self.navigationController.theme rightBarButtonItemWithTitle:text target:self action:@selector(rightBarButtonItemClicked:)];
    BarButtonItemHandlerObject *object = [BarButtonItemHandlerObject objectWithFunctionName:callbackFunctionName];
    NSNumber *key = @(rightBarButtonItem.hash);
    
    [barButtonItemHandlerObjectDic setObject:object forKey:key];
    [self.navigationItem addRightBarButtonItem:rightBarButtonItem];
}

- (void)openLayerBridgeWebViewWithURL:(NSString *)url layerOption :(LayerOption)layerOption
{
    UILayerBridgeWebViewController *controller = [[UILayerBridgeWebViewController alloc] init];
    controller.layerOption = layerOption;
    controller.destination = [NSURL URLWithString:url];
    
    [controller showInView:self.view.window];
    [self addChildViewController:controller];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - UIRefreshcontrol selector

- (void)refresh
{
    refreshing = YES;
    
    [self load];
}

#pragma mark - Navigation item selector

- (void)leftBarButtonItemClicked
{
    if ([self navigationShouldPopOnBackButton])
        [self close];
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:didClickRightBarButtonItemNotification object:self];
    
    NSNumber *key = @(sender.hash);
    BarButtonItemHandlerObject *object = barButtonItemHandlerObjectDic[key];
    
    if (object.functionName)
        [self.webView stringByEvaluatingJavaScriptFromString:[object.functionName stringByAppendingFormat:@"();"]];
}

@end

// ================================================================================================
//
//  Implementation: BarButtonItemHandlerObject
//
// ================================================================================================

@implementation BarButtonItemHandlerObject
+ (BarButtonItemHandlerObject *)objectWithFunctionName:(NSString *)functionName
{
    BarButtonItemHandlerObject *object = [[BarButtonItemHandlerObject alloc] init];
    object.functionName = functionName;
    return object;
}
@end