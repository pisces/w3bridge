/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */


#import "CDVPlugin.h"

@implementation NSObject (JSString)
- (NSString *)JSStringValue
{
    if (self)
        return [self isKindOfClass:[NSNull class]] || [((NSString *) self) isEqualToString:@"null"] ? nil : (NSString *) self;
    return nil;
}
@end

@implementation CDVPlugin
@synthesize webView, settings, viewController, commandDelegate;


- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView settings:(NSDictionary*)classSettings
{
    self = [self initWithWebView:theWebView];
    if (self) {
        self.settings = classSettings;
	}
    return self;
}

- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:CDVPluginHandleOpenURLNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:CDVPluginViewWillAppearNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:CDVPluginViewDidAppearNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisappear:) name:CDVPluginViewWillDisappearNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:CDVPluginViewDidDisappearNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidUnload:) name:CDVPluginViewDidUnloadNotification object:nil];
        
		self.webView = theWebView;
	}
    return self;
}

/*
 The arguments passed in should not included the callbackId.
 If argument count is not as expected, it will call the error callback using PluginResult (if callbackId is available),
 or it will write to stderr using NSLog.
 
 Usage is through the VERIFY_ARGUMENTS macro.
 */
- (BOOL) verifyArguments:(NSMutableArray*)arguments withExpectedCount:(NSUInteger)expectedCount andCallbackId:(NSString*)callbackId
		  callerFileName:(const char*)callerFileName callerFunctionName:(const char*)callerFunctionName
{
	NSUInteger argc = [arguments count];
	BOOL ok = (argc >= expectedCount); // allow for optional arguments
	
	if (!ok) {
		NSString* errorString = [NSString stringWithFormat:@"Incorrect no. of arguments for plugin: was %tu, expected %zd", argc, expectedCount];
		if (callbackId) {
			NSString* callbackId = [arguments objectAtIndex:0];
			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorString];
			[self writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
		} else {
#if DEBUG
            NSString *fileName = [[[NSString alloc] initWithBytes:callerFileName length:strlen(callerFileName) encoding:NSUTF8StringEncoding] lastPathComponent];
            NSLog(@"%@::%s - Error: %@", fileName, callerFunctionName, errorString);
#endif
		}
	}
	
	return ok;
}

/* NOTE: calls into JavaScript must not call or trigger any blocking UI, like alerts */
- (void) handleOpenURL:(NSNotification*)notification
{
	// override to handle urls sent to your app
	// register your url schemes in your App-Info.plist
	
	NSURL* url = [notification object];
	if ([url isKindOfClass:[NSURL class]]) {
		/* Do your thing! */
	}
}

/* NOTE: calls into JavaScript must not call or trigger any blocking UI, like alerts */
- (void) onAppTerminate
{
	// override this if you need to do any cleanup on app exit
}

- (void) onMemoryWarning
{
	// override to remove caches, etc
}

- (void) webViewDidStartLoad:(NSNotification*)notification
{
}
- (void) viewWillAppear:(NSNotification *)notification
{
}
- (void) viewDidAppear:(NSNotification *)notification
{
}
- (void) viewWillDisappear:(NSNotification *)notification
{
}
- (void) viewDidDisappear:(NSNotification *)notification
{
}
- (void) viewDidUnload:(NSNotification *)notification
{
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginHandleOpenURLNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginViewWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginViewDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginViewWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginViewDidDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginViewDidUnloadNotification object:nil];
    
    self.currentArguments = nil;
    self.currentOptions = nil;
	self.settings = nil;
	self.webView = nil;
    self.viewController = nil;
    self.commandDelegate = nil;
}

- (id) appDelegate
{
	return [[UIApplication sharedApplication] delegate];
}

/* deprecated - just use the viewController property */
- (UIViewController*) appViewController
{
	return self.viewController;
}

- (id)objectAtIndex:(int)index withArguments:(NSArray *)arguments
{
    return arguments.count > index ? [arguments objectAtIndex:index] : nil;
}

- (NSString*) writeJavascript:(NSString*)javascript
{
	return [self.webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (NSString *)callJavascriptFunction:(NSString *)functionName sendParam:(NSString *)sendParam
{
    if (functionName)
    {
        NSString *sendParamString = sendParam ? sendParam : @"";
        NSString *javascript = [functionName stringByAppendingFormat:@"(%@);", sendParamString];
        return [self.webView stringByEvaluatingJavaScriptFromString:javascript];
    }
    return nil;
}

- (NSString*) success:(CDVPluginResult*)pluginResult callbackId:(NSString*)callbackId
{
	return [self writeJavascript:[NSString stringWithFormat:@"setTimeout(function() { %@; }, 0);", [pluginResult toSuccessCallbackString:callbackId]]];
}

- (NSString*) error:(CDVPluginResult*)pluginResult callbackId:(NSString*)callbackId
{
	return [self writeJavascript:[NSString stringWithFormat:@"setTimeout(function() { %@; }, 0);", [pluginResult toErrorCallbackString:callbackId]]];
}

@end