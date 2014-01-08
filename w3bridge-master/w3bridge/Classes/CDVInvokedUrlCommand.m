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

#import "CDVInvokedUrlCommand.h"

@implementation CDVInvokedUrlCommand

@synthesize arguments;
@synthesize options;
@synthesize className;
@synthesize methodName;

+ (CDVInvokedUrlCommand*) commandFromObject:(NSDictionary*)object
{
    CDVInvokedUrlCommand* iuc = [[[CDVInvokedUrlCommand alloc] init] autorelease];
    iuc.className = [object objectForKey:@"className"];
    iuc.methodName = [object objectForKey:@"methodName"];
    iuc.arguments = [object objectForKey:@"arguments"];
    iuc.options = [object objectForKey:@"options"];

    return iuc;
}

- (void) dealloc
{
    [arguments release];
    [options release];
    [className release];
    [methodName release];
    
    [super dealloc];
}

@end
