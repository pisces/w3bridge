//
//  SimpleBridgeWebViewController.m
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

#import "SimpleBridgeWebViewController.h"
#import "w3bridge.h"

NSString *const webViewDidFailLoadWithErrorNotification = @"webViewDidFailLoadWithErrorNotification";
NSString *const webViewDidFinishLoadNotification = @"webViewDidFinishLoadNotification";
NSString *const webViewDidStartLoadNotification = @"webViewDidStartLoadNotification";

// ================================================================================================
//
//  Implementation: SimpleBridgeWebViewController
//
// ================================================================================================

@implementation SimpleBridgeWebViewController
{
@private
    BOOL loadFromInternal;
    BOOL scrollEnabledChanged;
    BOOL webViewSynthesized;
    NSString *cachedPureURLString;
    NSMutableArray *callbackQueue;
    NSMutableArray *notificationObjects;
    NSURLRequest *copiedRequest;
}

// ================================================================================================
//  Overridden: PSUIViewController
// ================================================================================================

#pragma mark - Overridden: PSUIViewController

- (BOOL)closeAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self clear];
    
    return [super closeAnimated:animated completion:completion];
}

- (void)commitProperties
{
    if (scrollEnabledChanged)
    {
        scrollEnabledChanged = NO;
        self.scrollViewOnWebView.scrollEnabled = self.scrollEnabled;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginViewDidUnloadNotification object:nil];
    [self clear];
}

- (void)initProperties
{
    [super initProperties];
    
    self.scrollEnabled = YES;
    _isFirstLoad = YES;
    callbackQueue = [[NSMutableArray alloc] init];
    notificationObjects = [[NSMutableArray alloc] init];
}

- (void)loadView
{
    [super loadView];
    
    _commandDelegate = self;
    webViewSynthesized = _webView != nil;
    
    if (!_sessionKey)
        _sessionKey = [NSString stringWithFormat:@"%d", arc4random()];
    
    [self setUpSubviews];
    [self setPropertiesFromPlist];
    [self setCookieAcceptPolicy];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginViewWillAppearNotification object:nil];
    
    if (!webViewSynthesized)
        _webView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginViewDidAppearNotification object:nil];
    
    if (!self.viewPushed && (self.isFirstLoad || self.reloadable))
        [self load];
    
    _viewPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginViewWillDisappearNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVPluginViewDidDisappearNotification object:nil];
    
    copiedRequest = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)updateWithReachability:(Reachability *)aReachability
{
    [super updateWithReachability:aReachability];
    
    if (self.isNotReachableBefore)
        [self load];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setDestination:(NSURL *)destination
{
    if ([destination isEqual:_destination])
        return;
    
    _destination = destination;
    
    if (self.isViewAppeared)
    {
        cachedPureURLString = nil;
        copiedRequest = nil;
        
        [self load];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (scrollEnabled == _scrollEnabled)
        return;
    
    _scrollEnabled = scrollEnabled;
    scrollEnabledChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)addNotification:(BridgeNotification *)notification
{
    if (!notification)
        return;
    
    BOOL hasNotification = NO;
    NSString *name = [[notification.currentArguments objectAtIndex:1] JSStringValue];
    NSString *callbackString = [[notification.currentArguments objectAtIndex:2] JSStringValue];
    id _uniqueKey = [notification.currentArguments objectAtIndex:3];
    NSString *uniqueKey = [_uniqueKey isKindOfClass:[NSNumber class]] ? [_uniqueKey stringValue] : [_uniqueKey JSStringValue];
    for (NSDictionary *item in notificationObjects)
    {
        NSString *itemName = [item objectForKey:@"name"];
        NSString *itemCallbackString = [item objectForKey:@"callbackString"];
        NSString *itemUniqueKey = [item objectForKey:@"uniqueKey"];
        BOOL existNameAndCallback = [name isEqualToString:itemName] && [callbackString isEqualToString:itemCallbackString];
        BOOL validation = [self canReceiveNotificationSelfOnly:name] ? existNameAndCallback : existNameAndCallback && [uniqueKey isEqualToString:itemUniqueKey];
        
        if (validation)
        {
            hasNotification = YES;
            break;
        }
    }
    
    if (!hasNotification)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", callbackString, @"callbackString", uniqueKey, @"uniqueKey", nil];
        [notificationObjects addObject:dic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:name object:[self canReceiveNotificationSelfOnly:name] ? self : nil];
    }
}

- (BOOL)canReceiveNotificationSelfOnly:(NSString *)name;
{
    return NO;
}

- (void)clear
{
    [callbackQueue removeAllObjects];
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView removeFromSuperview];
    
    callbackQueue = nil;
    notificationObjects = nil;
    copiedRequest = nil;
    cachedPureURLString = nil;
    _pluginObjects = nil;
    _pluginsMap = nil;
    _settings = nil;
    _sessionKey = nil;
    _destination = nil;
    _scrollViewOnWebView = nil;
    _webView.delegate = nil;
    _webView = nil;
}

- (NSString *)executeJSFunc:(NSString *)functionName withObject:(NSDictionary *)object
{
    if (functionName)
    {
        NSString *objectString = object ? [object JSONString] : @"";
        NSString *script = [functionName stringByAppendingFormat:@"(%@);", objectString];
        return [self.webView stringByEvaluatingJavaScriptFromString:script];
    }
    return nil;
}

- (NSInteger)executeQueuedCommands
{
    NSString* queuedCommandsJSON = [_webView stringByEvaluatingJavaScriptFromString:@"Cordova.getAndClearQueuedCommands()"];
    NSArray* queuedCommands = [queuedCommandsJSON objectFromJSONString];
    for (NSString* commandJson in queuedCommands) {
        if(![_commandDelegate execute:
             [CDVInvokedUrlCommand commandFromObject:
              [commandJson mutableObjectFromJSONString]]])
		{
#if DEBUG
			NSLog(@"FAILED pluginJSON = %@",commandJson);
#endif
		}
    }
    return [queuedCommands count];
}

- (void)flushCommandQueue
{
    [_webView stringByEvaluatingJavaScriptFromString:@"Cordova.commandQueueFlushing = true"];
	
    NSInteger numExecutedCommands = 0;
    do {
        numExecutedCommands = [self executeQueuedCommands];
    } while (numExecutedCommands != 0);
	
    [_webView stringByEvaluatingJavaScriptFromString:@"Cordova.commandQueueFlushing = false"];
}

- (void)load
{
    if ([self.exceptionViewController checkVisibility])
        return;
    
    if (_destination && _webView)
    {
        loadFromInternal = YES;
        NSMutableURLRequest *request = copiedRequest ? (NSMutableURLRequest *) copiedRequest : [NSMutableURLRequest requestWithURL:_destination cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSDictionary *headers = [HTTPActionManager sharedInstance].headers;
        
        if (headers)
        {
            for (NSString *key in headers)
                [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        
        [_webView stopLoading];
        [_webView loadRequest:request];
        
        _receiveShouldStartLoading = NO;
    }
}

- (void)removeNotification:(BridgeNotification *)notification
{
    NSString *name = [[notification.currentArguments objectAtIndex:1] JSStringValue];
    NSString *callbackString = [[notification.currentArguments objectAtIndex:2] JSStringValue];
    NSString *uniqueKey = [[notification.currentArguments objectAtIndex:3] JSStringValue];
    for (NSDictionary *item in notificationObjects)
    {
        NSString *itemName = [item objectForKey:@"name"];
        NSString *itemCallbackString = [item objectForKey:@"callbackString"];
        NSString *itemUniqueKey = [item objectForKey:@"uniqueKey"];
        BOOL existNameAndCallback = [name isEqualToString:itemName] && [callbackString isEqualToString:itemCallbackString];
        BOOL validation = [self canReceiveNotificationSelfOnly:name] ? existNameAndCallback : existNameAndCallback && [uniqueKey isEqualToString:itemUniqueKey];
        if (validation)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:[self canReceiveNotificationSelfOnly:name] ? self : nil];
            [notificationObjects removeObject:item];
        }
    }
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (BOOL)allowedPassingURLWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *pureURLString = [self pureURLStringWithURL:request.URL];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:request.URL.absoluteString options:NSMatchingReportProgress range:(NSRange) {0, request.URL.absoluteString.length}];
    BOOL noChangeURL = (!error && matches && matches.count > 0) && (pureURLString && cachedPureURLString && [pureURLString isEqualToString:cachedPureURLString]);
    BOOL isFrameLoad = ![request.URL.absoluteString isEqual:request.mainDocumentURL.absoluteString];
#if DEBUG
    NSLog(@"\nallowedPassingURLWithRequest: URL -> %@\nmainDocumentURL -> %@\nnavigationType -> %d\nisFrameLoad -> %d\nnoChangeUrl -> %d\ncachedPureURLString -> %@\npureURLString -> %@\n", request.URL, request.mainDocumentURL, navigationType, isFrameLoad, noChangeURL, cachedPureURLString, pureURLString);
#endif
    if (noChangeURL)
    {
        copiedRequest = request;
        _destination = request.URL;
    }
    
    return noChangeURL || isFrameLoad || navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeFormResubmitted;
}

- (BOOL)allowedURLScheme:(NSString *)scheme
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http|https|about" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:scheme options:NSMatchingReportProgress range:(NSRange) {0, scheme.length}];
    return matches && matches.count > 0;
}

- (BOOL)execute:(CDVInvokedUrlCommand *)command
{
#if DEBUG
    NSLog(@"execute command from web -> %@", command.className);
#endif
    if (command.className == nil || command.methodName == nil)
        return NO;
    
    CDVPlugin* obj = [_commandDelegate getCommandInstance:command.className];
    if (!([obj isKindOfClass:[CDVPlugin class]])) {
#if DEBUG
        NSLog(@"ERROR: Plugin '%@' not found, or is not a CDVPlugin. Check your plugin mapping in w3bridge.plist.", command.className);
#endif
        return NO;
    }
    
    BOOL retVal = YES;
    
    NSString* fullMethodName = [[NSString alloc] initWithFormat:@"%@:withDict:", command.methodName];
    
#if DEBUG
    NSLog(@"fullMethodName -> %@", fullMethodName);
#endif
    
    SEL selector = NSSelectorFromString(fullMethodName);
    if ([obj respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [obj performSelector:selector withObject:command.arguments withObject:command.options];
    } else {
#if DEBUG
        NSLog(@"ERROR: Method '%@' not defined in Plugin '%@'", fullMethodName, command.className);
#endif
        retVal = NO;
    }
    return retVal;
}

#pragma mark - CordovaCommands

- (NSDictionary *)deviceProperties
{
    UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *devProps = [NSMutableDictionary dictionary];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    [devProps setObject:[device model] forKey:@"platform"];
    [devProps setObject:@([device deviceFamily]) forKey:@"platformType"];
    [devProps setObject:[device modelName] forKey:@"platformString"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
    [devProps setObject:uuidString forKey:@"uuid"];
    [devProps setObject:[device name] forKey:@"name"];
    [devProps setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"appId"];
    [devProps setObject:APPLICATION_VERSION forKey:@"appVersion"];
    [devProps setObject:@(IS_RETINA) forKey:@"isRetina"];
    [devProps setObject:@([self freeMemory]) forKey:@"freeMemory"];
    
    CFRelease(uuid);
    
    return devProps;
}

- (natural_t)freeMemory
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = (natural_t) (vm_stat.free_count * pagesize);
    
    return mem_free;
}

- (id)getCommandInstance:(NSString *)pluginName
{
    NSString* className = [_pluginsMap objectForKey:[pluginName lowercaseString]];
    
    if (className == nil)
        return nil;
    
    id obj = [_pluginObjects objectForKey:className];
    if (!obj)
    {
        NSDictionary* classSettings = [_settings objectForKey:className];
		
        if (classSettings) {
            obj = [[NSClassFromString(className) alloc] initWithWebView:_webView settings:classSettings];
        } else {
            obj = [[NSClassFromString(className) alloc] initWithWebView:_webView];
        }
        
        if ([obj isKindOfClass:[CDVPlugin class]] && [obj respondsToSelector:@selector(setViewController:)]) {
            [obj setViewController:self];
        }
        
        if ([obj isKindOfClass:[CDVPlugin class]] && [obj respondsToSelector:@selector(setCommandDelegate:)]) {
            [obj setCommandDelegate:_commandDelegate];
        }
        
        if (obj != nil) {
            [_pluginObjects setObject:obj forKey:className];
        } else {
#if DEBUG
            NSLog(@"CDVPlugin class %@ (pluginName: %@) does not exist.", className, pluginName);
#endif
        }
    }
    return obj;
}

- (NSString *)pureURLStringWithURL:(NSURL *)url
{
    NSArray *seperatedStringList = [url.absoluteString componentsSeparatedByString:@"?"];
    return seperatedStringList && seperatedStringList.count > 0 ? [seperatedStringList objectAtIndex:0] : url.absoluteString;
}

- (void)resumeNotificationReceive
{
    for (NSDictionary *item in notificationObjects)
    {
        NSString *name = [item objectForKey:@"name"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:name object:[name isEqualToString:@"shouldAutorotate"] ? self : nil];
    }
}

- (void)removeNotifications
{
    for (NSDictionary *item in notificationObjects)
    {
        NSString *name = [item objectForKey:@"name"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    }
    [notificationObjects removeAllObjects];
}

- (void)setCookieAcceptPolicy
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

- (void)setPropertiesFromPlist
{
    _pluginObjects = [[NSMutableDictionary alloc] init];
    
    NSString* appPlistName = @"w3bridge";
    NSDictionary* bridgePlist = [[NSBundle mainBundle] dictionaryWithPlistName:appPlistName];
    if (bridgePlist == nil) {
#if DEBUG
        NSLog(@"WARNING: %@.plist is missing.", appPlistName);
#endif
		return;
    }
    
    _settings = [[NSDictionary alloc] initWithDictionary:bridgePlist];
	
    NSDictionary* pluginsDict = [_settings objectForKey:@"Plugins"];
    if (pluginsDict == nil) {
#if DEBUG
        NSString* pluginsKey = @"Plugins";
        NSLog(@"WARNING: %@ key in %@.plist is missing! Cordova will not work, you need to have this key.", pluginsKey, appPlistName);
#endif
        return;
    }
    
    _pluginsMap = [pluginsDict dictionaryWithLowercaseKeys];
}

- (void)setUpSubviews
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] init];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        
        [self.view addSubview:_webView];
    }
    
    for (UIView *subView in _webView.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
            _scrollViewOnWebView = (UIScrollView *) subView;
    }
    
    for (UIView *wview in [[_webView.subviews objectAtIndex:0] subviews])
    {
        if([wview isKindOfClass:[UIImageView class]])
            wview.hidden = YES;
    }
    
    _exceptionViewController = [[PSExceptionViewController alloc] initWithSuperview:self.view];
    _exceptionViewController.buttonTitleText = [w3bridge localizedStringWithKey:@"exception-retry-noreachable"];
    _exceptionViewController.descriptionText = [w3bridge localizedStringWithKey:@"exception-desc-noreachable"];
    _exceptionViewController.titleText = [w3bridge localizedStringWithKey:@"exception-title-noreachable"];
    _exceptionViewController.delegate = self;
}

- (void)stopNotificationReceive
{
    for (NSDictionary *item in notificationObjects)
    {
        NSString *name = [item objectForKey:@"name"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    }
}

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"gap"])
    {
        [self flushCommandQueue];
        return NO;
    }
    
    if (![self allowedURLScheme:request.URL.scheme])
    {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL])
            [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    if ([self allowedPassingURLWithRequest:request navigationType:navigationType])
        return  YES;
    
    if ([self allowedURLScheme:request.URL.scheme])
    {
        BOOL _loadFromInternal = loadFromInternal;
        loadFromInternal = NO;
        
        if (!_loadFromInternal)
        {
            _receiveShouldStartLoading = YES;
            copiedRequest = request;
            _destination = request.URL;
            
            [self load];
            return NO;
        }
    }
    
    cachedPureURLString = [self pureURLStringWithURL:request.URL];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    copiedRequest = nil;
    
    [callbackQueue removeAllObjects];
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:webViewDidStartLoadNotification object:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    copiedRequest = nil;
    _isFirstLoad = NO;
    
    @try {
        NSDictionary *deviceProperties = [self deviceProperties];
        NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"DeviceInfo = %@;", [deviceProperties JSONString]];
        NSString *sessionKeyScript = [NSString stringWithFormat:@"Cordova.sessionKey = \"%@\";", _sessionKey];
        
        [theWebView stringByEvaluatingJavaScriptFromString:sessionKeyScript];
        [theWebView stringByEvaluatingJavaScriptFromString:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:webViewDidFinishLoadNotification object:self];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"deviceProperties error: %@", exception);
#endif
    }
    @finally {
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    copiedRequest = nil;
    _isFirstLoad = NO;
#if DEBUG
    NSLog(@"Failed to load webpage with error: %@", error);
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:webViewDidFailLoadWithErrorNotification object:self];
}

#pragma mark - BridgeExternalInterface delegate

- (void)addCallbackId:(NSString *)callbackId withName:(NSString *)name
{
    [callbackQueue addObject:@{@"callbackId": callbackId, @"name": name}];
}

- (void)callbackWithName:(NSString *)name withResult:(NSDictionary *)result
{
    for (NSDictionary *dic in callbackQueue)
    {
        NSString *callbackName = [dic objectForKey:@"name"];
        if ([name isEqualToString:callbackName])
        {
            NSString *callbackId = [dic objectForKey:@"callbackId"];
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimeout(function() { %@; }, 0);", [pluginResult toSuccessCallbackString:callbackId]]];
        }
    }
}

- (NSDictionary *)executeExternalInterfaceWithName:(NSString *)name withOptions:(NSDictionary *)options
{
    return nil;
}

#pragma mark - PSExceptionViewController delegate

- (BOOL)exceptionViewShouldShowWithController:(PSExceptionViewController *)controller
{
    return self.isNotReachable;
}

- (void)controller:(PSExceptionViewController *)controller buttonClicked:(id)sender
{
    [self load];
}

#pragma mark - Notification selector

- (void)receiveNotification:(NSNotification *)notification
{
    for (NSDictionary *item in notificationObjects)
    {
        NSString *name = [item objectForKey:@"name"];
        NSString *uniqueKey = [item objectForKey:@"uniqueKey"];
        NSString *receivedUniqueKey = [notification.userInfo objectForKey:@"uniqueKey"];
        BOOL existName = [notification.name isEqualToString:name];
        BOOL validation = [self canReceiveNotificationSelfOnly:name] ? existName : existName && [uniqueKey isEqualToString:receivedUniqueKey];
        if (validation)
        {
            NSString *callbackString = [item objectForKey:@"callbackString"];
            if (callbackString)
            {
                NSString *query = [callbackString stringByAppendingFormat:@"(%@);", [notification.userInfo JSONString]];
                [_webView stringByEvaluatingJavaScriptFromString:query];
            }
        }
    }
}
@end

// ================================================================================================
//
//  Category: UIWebView (org_apache_w3bridge_UIWebView)
//
// ================================================================================================

static BOOL diagStat = NO;

@implementation UIWebView (org_apache_w3bridge_UIWebView)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    UIAlertView *alertDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:[w3bridge localizedStringWithKey:@"ok"] otherButtonTitles:nil];
    [alertDiag show];
}

- (BOOL)webView:(id)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:[w3bridge localizedStringWithKey:@"cancel"] otherButtonTitles:[w3bridge localizedStringWithKey:@"ok"], nil];
    
    [confirmDiag show];
    
    while (confirmDiag.hidden == NO)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView.hidden = YES;
    diagStat = buttonIndex == 1;
}

@end
