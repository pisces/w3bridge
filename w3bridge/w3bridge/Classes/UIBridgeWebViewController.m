//
//  UIBridgeViewController.m
//  w3bridge
//
//  Created by KH Kim on 2013. 12. 31..
//  Copyright (c) 2013 KH Kim. All rights reserved.
//

/*
 Copyright 2013 ~ 2014 KH Kim
 
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

// ================================================================================================
//
//  Implementation
//
// ================================================================================================

#define NumLinesMax 3

@implementation UIBridgeWebViewController
{
@private
    NSString *rightBarButtonClickCallBack;
    NSDate *updateDate;
    PSUIRefreshViewController *refreshViewController;
}

// ================================================================================================
//  View Cycle
// ================================================================================================

- (void)clear
{
    [super clear];
    
    [self.navigationItem removeLeftBarButtonItem];
    [self.navigationItem removeRightBarButtonItem];
    
    [refreshViewController.view removeFromSuperview];
    
    rightBarButtonClickCallBack = nil;
    updateDate = nil;
    refreshViewController = nil;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return _hidesBottomBarWhenPushed;
}

- (BOOL)navigationShouldPopOnBackButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:didClickLeftBarButtonItemNotification object:self];
    return self.isFirstLoad ? YES : _closeEnabled;
}

- (void)loadView
{   
    [super loadView];
    
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.view.layer.shouldRasterize = YES;
    
    if (_useDocumentTitle)
        self.title = nil;
    
    self.useRefreshDisplay = YES;
    
    [self setLeftBarButtonItem];
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
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:interfaceOrientation] forKey:@"interfaceOrientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:shouldAutorotateNotification object:self userInfo:userInfo];
    
    if (_interfaceOrientationState == 1)
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    else if (_interfaceOrientationState == 2)
        return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (_interfaceOrientationState == 1)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    if (_interfaceOrientationState == 2)
        return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.interfaceOrientation] forKey:@"interfaceOrientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:shouldAutorotateNotification object:self userInfo:userInfo];
    return _interfaceOrientationState > 0;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (_interfaceOrientationState == 1)
    {
        return self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? UIInterfaceOrientationPortrait : self.interfaceOrientation;
    }
    else if (_interfaceOrientationState == 2)
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

// ================================================================================================
//  Overridden: SimpleBridgeWebViewController
// ================================================================================================

- (id)init
{
    self = [super init];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initProperties];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        [self initProperties];
    return self;
}

// ================================================================================================
//  Delegate
// ================================================================================================

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshEnabled)
        refreshViewController.contentOffset = scrollView.contentOffset;
    
    [ActivityIndicatorManager layout:self.scrollViewOnWebView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    if (self.isFirstLoad || self.receiveShouldStartLoading || !_refreshEnabled ||
        !refreshViewController.target || refreshViewController.updating ||
        aScrollView.contentOffset.y > refreshViewController.reloadBoundsHeight*-1)
        return;
    
    refreshViewController.updating = YES;
    [self.webView reload];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView*)theWebView 
{
    if (refreshViewController.updating)
        return;
    
    [super webViewDidStartLoad:theWebView];
    
    if (self.isFirstLoad)
    {
        if (_showModalWhenFirstLoading)
        {
            [ActivityIndicatorManager activate:self.scrollViewOnWebView message:@"불러오는 중" modal:YES];
            [ActivityIndicatorManager layout:self.scrollViewOnWebView layoutStyle:ActivityIndicatorLayoutStyleTop];
            
        }
        else
        {
            [ActivityIndicatorManager activate:self.scrollViewOnWebView modal:NO];
        }
    }
    else
    {
        if (!refreshViewController.updating)
            [ActivityIndicatorManager activate:self.scrollViewOnWebView modal:NO];
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView 
{
    [super webViewDidFinishLoad:theWebView];
    
    updateDate = [NSDate date];
    
    if (_refreshEnabled)
    {
        refreshViewController.updateDate = updateDate;
        refreshViewController.updating = NO;
        refreshViewController.view.hidden = NO;
    }
    
    [ActivityIndicatorManager deactivate:self.scrollViewOnWebView];
    
    NSString *title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_useDocumentTitle && title && title.length > 0)
        self.title = title;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error 
{
    [super webView:webView didFailLoadWithError:error];
    
    if (_refreshEnabled)
    {
        refreshViewController.updating = NO;
        refreshViewController.view.hidden = NO;
    }
    
    [ActivityIndicatorManager deactivate:self.scrollViewOnWebView];
}

// ================================================================================================
//  Public
// ================================================================================================

- (BOOL)canReceiveNotificationSelfOnly:(NSString *)name
{
    return [name isEqualToString:shouldAutorotateNotification] || [name isEqualToString:textViewBlurNotification] ||
    [name isEqualToString:textViewFocusNotification] || [name isEqualToString:viewDidAppearNotification] ||
    [name isEqualToString:viewDidDisappearNotification] || [name isEqualToString:viewWillAppearNotification] ||
    [name isEqualToString:viewWillDisappearNotification] || [name isEqualToString:willCloseViewNotification] ||
    [name isEqualToString:didClickLeftBarButtonItemNotification] || [name isEqualToString:didClickRightBarButtonItemNotification];
}

- (void)openLayerBridgeWebViewWithURL:(NSString *)url layerOption :(LayerOption)layerOption
{
    UILayerBridgeWebViewController *controller = [[UILayerBridgeWebViewController alloc] init];
    controller.layerOption = layerOption;
    controller.destination = [NSURL URLWithString:url];
    
    [controller showInView:self.view.window];
}

- (void)setRightBarButtonItemWithText:(NSString *)text buttonClickCallBack:(NSString *)buttonClickCallBack
{
    rightBarButtonClickCallBack = buttonClickCallBack;
    UIBarButtonItem *rightBarButtonItem = [self.navigationController.theme rightBarButtonItemWithTitle:text target:self action:@selector(rightBarButtonItemClicked)];
    
    [self.navigationItem addRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem getRightBarButtonItem].customView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^(void){
        [self.navigationItem getRightBarButtonItem].customView.alpha = 1;
    }];
}

// ================================================================================================
//  Internal
// ================================================================================================

- (void)initProperties
{
    self.reloadable = NO;
    self.scrollEnabled = YES;
    _hidesBottomBarWhenPushed = NO;
    _closeEnabled = YES;
    _refreshEnabled = YES;
    _showModalWhenFirstLoading = YES;
    _useDocumentTitle = YES;
    _leftBarButtonItemType = LeftBarButtonItemTypeNone;
}

- (void)setLeftBarButtonItem
{
    UIBarButtonItem *leftBarButtonItem;
    
    if ([self.navigationController respondsToSelector:@selector(previousTitle)] && self.navigationController.previousTitle)
    {
        leftBarButtonItem = [self.navigationController.theme backBarButtonItemWithTitle:_leftBarButtonItemText ? _leftBarButtonItemText : @"이전" target:self action:@selector(leftBarButtonItemClicked)];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
            self.navigationController.previousViewController.navigationItem.backBarButtonItem = leftBarButtonItem;
        else
            [self.navigationItem addLeftBarButtonItem:leftBarButtonItem];
    }
    else if (_leftBarButtonItemType != LeftBarButtonItemTypeNone)
    {
        if (_leftBarButtonItemType == LeftBarButtonItemTypeHome)
            leftBarButtonItem = [self.navigationController.theme homeBarButtonItemWithTarget:self action:@selector(leftBarButtonItemClicked)];
        else if (_leftBarButtonItemType == LeftBarButtonItemTypeClose)
            leftBarButtonItem = [self.navigationController.theme closeBarButtonItemWithTarget:self action:@selector(leftBarButtonItemClicked)];
        else if (_leftBarButtonItemType == LeftBarButtonItemTypeCustom)
            leftBarButtonItem = [self.navigationController.theme leftBarButtonItemWithTitle:_leftBarButtonItemText target:self action:@selector(leftBarButtonItemClicked)];
        
        [self.navigationItem addLeftBarButtonItem:leftBarButtonItem];
    }
}

// ================================================================================================
//  Setters
// ================================================================================================

- (void)setRefreshEnabled:(BOOL)refreshEnabled
{
    if (refreshEnabled == _refreshEnabled)
        return;
    
    _refreshEnabled = refreshEnabled;
    
    if (!_refreshEnabled)
        self.useRefreshDisplay = NO;
}

- (void)setUseRefreshDisplay:(BOOL)useRefreshDisplay
{
    if (useRefreshDisplay == _useRefreshDisplay)
        return;
    
    _useRefreshDisplay = useRefreshDisplay;
    
    if (_useRefreshDisplay)
    {
        if (_refreshEnabled)
        {
            refreshViewController = [[PSUIRefreshViewController alloc] init];
            refreshViewController.target = self.scrollViewOnWebView;
            refreshViewController.updateDate = updateDate;
            self.scrollViewOnWebView.delegate = self;
        }
    }
    else
    {
        self.scrollViewOnWebView.delegate = nil;
        refreshViewController.view.hidden = YES;
        refreshViewController.updating = NO;
        
        [refreshViewController.view removeFromSuperview];
        refreshViewController = nil;
    }
}

// ================================================================================================
//  Selectors
// ================================================================================================

- (void)leftBarButtonItemClicked
{
    if ([self navigationShouldPopOnBackButton])
        [self close];
}

- (void)rightBarButtonItemClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:didClickRightBarButtonItemNotification object:self];
    
    if (rightBarButtonClickCallBack)
    {
        NSString *query = [rightBarButtonClickCallBack stringByAppendingFormat:@"();"];
        [self.webView stringByEvaluatingJavaScriptFromString:query];
    }
}
@end
