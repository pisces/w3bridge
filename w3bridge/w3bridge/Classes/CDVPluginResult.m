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

#import "CDVPluginResult.h"

@interface CDVPluginResult()

-(CDVPluginResult*) initWithStatus:(CDVCommandStatus)statusOrdinal message: (id) theMessage cast: (NSString*) theCast;

@end


@implementation CDVPluginResult
@synthesize status, message, keepCallback, cast;

static NSArray* org_apache_cordova_CommandStatusMsgs;

+(void) initialize
{
	org_apache_cordova_CommandStatusMsgs = [[NSArray alloc] initWithObjects: @"No result",
                                            @"OK",
                                            @"Class not found",
                                            @"Illegal access",
                                            @"Instantiation error",
                                            @"Malformed url",
                                            @"IO error",
                                            @"Invalid action",
                                            @"JSON error",
                                            @"Error",
                                            nil];
}
+(void) releaseStatus
{
	org_apache_cordova_CommandStatusMsgs = nil;
}

-(CDVPluginResult*) init
{
	return [self initWithStatus: CDVCommandStatus_NO_RESULT message: nil cast: nil];
}
-(CDVPluginResult*) initWithStatus:(CDVCommandStatus)statusOrdinal message: (id) theMessage cast: (NSString*) theCast{
	self = [super init];
	if(self) {
		status = [NSNumber numberWithInt: statusOrdinal];
		message = theMessage;
		cast = theCast;
		keepCallback = [NSNumber numberWithBool: NO];
	}
	return self;
}

+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal
{
	return [[self alloc] initWithStatus: statusOrdinal message: [org_apache_cordova_CommandStatusMsgs objectAtIndex: statusOrdinal] cast: nil];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsString: (NSString*) theMessage
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:nil];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsArray: (NSArray*) theMessage
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:nil];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsInt: (int) theMessage
{
	return [[self alloc] initWithStatus: statusOrdinal message: [NSNumber numberWithInt: theMessage] cast:nil];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsDouble: (double) theMessage
{
	return [[self alloc] initWithStatus: statusOrdinal message: [NSNumber numberWithDouble: theMessage] cast:nil];
}

+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsDictionary: (NSDictionary*) theMessage
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:nil];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsString: (NSString*) theMessage cast: (NSString*) theCast
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:theCast];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsArray: (NSArray*) theMessage cast: (NSString*) theCast
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:theCast];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsInt: (int) theMessage cast: (NSString*) theCast
{
	return [[self alloc] initWithStatus: statusOrdinal message: [NSNumber numberWithInt: theMessage] cast:theCast];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsDouble: (double) theMessage cast: (NSString*) theCast
{
	return [[self alloc] initWithStatus: statusOrdinal message: [NSNumber numberWithDouble: theMessage] cast:theCast];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageAsDictionary: (NSDictionary*) theMessage cast: (NSString*) theCast
{
	return [[self alloc] initWithStatus: statusOrdinal message: theMessage cast:theCast];
}
+(CDVPluginResult*) resultWithStatus: (CDVCommandStatus) statusOrdinal messageToErrorObject: (int) errorCode
{
    NSDictionary* errDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:errorCode] forKey:@"code"];
	return [[self alloc] initWithStatus: statusOrdinal message: errDict cast:nil];
}


-(void) setKeepCallbackAsBool:(BOOL)bKeepCallback
{
	[self setKeepCallback: [NSNumber numberWithBool:bKeepCallback]];
}

-(NSString*) toJSONString{
    NSString* resultString = [[NSDictionary dictionaryWithObjectsAndKeys:
                               self.status, @"status",
                               self.message ? self.message : [NSNull null], @"message",
                               self.keepCallback, @"keepCallback",
                               nil] JSONString];
	return resultString;
}
-(NSString*) toSuccessCallbackString: (NSString*) callbackId
{
	NSString* successCB;
	
	if ([self cast] != nil) {
		successCB = [NSString stringWithFormat: @"var temp = %@(%@);\nCordova.callbackSuccess('%@',temp);", self.cast, [self toJSONString], callbackId];
	}
	else {
		successCB = [NSString stringWithFormat:@"Cordova.callbackSuccess('%@',%@);", callbackId, [self toJSONString]];
	}
	return successCB;
}
-(NSString*) toErrorCallbackString: (NSString*) callbackId
{
	NSString* errorCB = nil;
	
	if ([self cast] != nil) {
		errorCB = [NSString stringWithFormat: @"var temp = %@(%@);\nCordova.callbackError('%@',temp);", self.cast, [self toJSONString], callbackId];
	}
	else {
		errorCB = [NSString stringWithFormat:@"Cordova.callbackError('%@',%@);", callbackId, [self toJSONString]];
	}
	return errorCB;
}	

-(void) dealloc
{
	status = nil;
	message = nil;
	keepCallback = nil;
	cast = nil;
}
@end
