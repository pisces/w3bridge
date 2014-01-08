/*     Cordova v1.5.0 */
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


/*
 * Some base contributions
 * Copyright (c) 2011, Proyectos Equis Ka, S.L.
 */

if (typeof Cordova === "undefined") {
    
    if (typeof(DeviceInfo) !== 'object'){
        DeviceInfo = {};
    }
    /**
     * This represents the Cordova API itself, and provides a global namespace for accessing
     * information about the state of Cordova.
     * @class
     */
    Cordova = {
        // This queue holds the currently executing command and all pending
        // commands executed with Cordova.exec().
    commandQueue: [],
        // Indicates if we're currently in the middle of flushing the command
        // queue on the native side.
    commandQueueFlushing: false,
    _constructors: [],
    documentEventHandler: {},   // Collection of custom document event handlers
    windowEventHandler: {} 
    };
    
    /**
     * List of resource files loaded by Cordova.
     * This is used to ensure JS and other files are loaded only once.
     */
    Cordova.resources = {base: true};
    
    /**
     * Determine if resource has been loaded by Cordova
     *
     * @param name
     * @return
     */
    Cordova.hasResource = function(name) {
        return Cordova.resources[name];
    };
    
    /**
     * Add a resource to list of loaded resources by Cordova
     *
     * @param name
     */
    Cordova.addResource = function(name) {
        Cordova.resources[name] = true;
    };
    
    /**
     * Boolean flag indicating if the Cordova API is available and initialized.
     */ // TODO: Remove this, it is unused here ... -jm
    Cordova.available = DeviceInfo.uuid != undefined;
    
    /**
     * Add an initialization function to a queue that ensures it will run and initialize
     * application constructors only once Cordova has been initialized.
     * @param {Function} func The function callback you want run once Cordova is initialized
     */
    Cordova.addConstructor = function(func) {
        var state = document.readyState;
        if ( ( state == 'loaded' || state == 'complete' ) && DeviceInfo.uuid != null )
        {
            func();
        }
        else
        {
            Cordova._constructors.push(func);
        }
    };
    
    Cordova.isValidPlatform = function() {
        if (navigator.isTest)
        	return true;
        var uagent = navigator.userAgent.toLowerCase();
        return uagent.search("iphone") > -1 || uagent.search("android") > -1;
    };

    if (Cordova.isValidPlatform()) {
        (function() 
        	     {
        	     var timer = setInterval(function()
        	                             {
        	                             
        	                             var state = document.readyState;
        	                             
        	                             if ( ( state == 'loaded' || state == 'complete' ) && (DeviceInfo.uuid != null || navigator.isTest) )
        	                             {
        	                             clearInterval(timer); // stop looking
        	                             // run our constructors list
        	                             while (Cordova._constructors.length > 0) 
        	                             {
        	                             var constructor = Cordova._constructors.shift();
        	                             try 
        	                             {
        	                             constructor();
        	                             } 
        	                             catch(e) 
        	                             {
        	                             if (typeof(console['log']) == 'function')
        	                             {
        	                             }
        	                             else
        	                             {
        	                             alert("Failed to run constructor: " + e.message);
        	                             }
        	                             }
        	                             }
        	                             // all constructors run, now fire the deviceready event
        	                             var e = document.createEvent('Events'); 
        	                             e.initEvent('deviceready');
        	                             document.dispatchEvent(e);
        	                             }
        	                             }, 1);
        	     })();
    }
    
    // session id for calls
    Cordova.sessionKey = 0;
    
    // centralized callbacks
    Cordova.callbackId = 0;
    Cordova.callbacks = {};
    Cordova.callbackStatus = {
    NO_RESULT: 0,
    OK: 1,
    CLASS_NOT_FOUND_EXCEPTION: 2,
    ILLEGAL_ACCESS_EXCEPTION: 3,
    INSTANTIATION_EXCEPTION: 4,
    MALFORMED_URL_EXCEPTION: 5,
    IO_EXCEPTION: 6,
    INVALID_ACTION: 7,
    JSON_EXCEPTION: 8,
    ERROR: 9
    };
    
    /**
     * Creates a gap bridge iframe used to notify the native code about queued
     * commands.
     *
     * @private
     */
    Cordova.createGapBridge = function() {
        gapBridge = document.createElement("iframe");
        gapBridge.setAttribute("style", "display:none;");
        gapBridge.setAttribute("height","0px");
        gapBridge.setAttribute("width","0px");
        gapBridge.setAttribute("frameborder","0");
        document.documentElement.appendChild(gapBridge);
        return gapBridge;
    };
    
    /** 
     * Execute a Cordova command by queuing it and letting the native side know
     * there are queued commands. The native side will then request all of the
     * queued commands and execute them.
     *
     * Arguments may be in one of two formats:
     *
     * FORMAT ONE (preferable)
     * The native side will call Cordova.callbackSuccess or
     * Cordova.callbackError, depending upon the result of the action.
     *
     * @param {Function} success    The success callback
     * @param {Function} fail       The fail callback
     * @param {String} service      The name of the service to use
     * @param {String} action       The name of the action to use
     * @param {String[]} [args]     Zero or more arguments to pass to the method
     *      
     * FORMAT TWO
     * @param {String} command    Command to be run in Cordova, e.g.
     *                            "ClassName.method"
     * @param {String[]} [args]   Zero or more arguments to pass to the method
     *                            object parameters are passed as an array object
     *                            [object1, object2] each object will be passed as
     *                            JSON strings 
     */
    Cordova.exec = function() {
        if (!Cordova.isValidPlatform())
        	return;
        	
        if (!Cordova.available) {
            alert("ERROR: Attempting to call Cordova.exec()"
                  +" before 'deviceready'. Ignoring.");
            return;
        }
        
        var successCallback, failCallback, service, action, actionArgs;
        var callbackId = null;
        if (typeof arguments[0] !== "string") {
            // FORMAT ONE
            successCallback = arguments[0];
            failCallback = arguments[1];
            service = arguments[2];
            action = arguments[3];
            actionArgs = arguments[4];
            
            // Since we need to maintain backwards compatibility, we have to pass
            // an invalid callbackId even if no callback was provided since plugins
            // will be expecting it. The Cordova.exec() implementation allocates
            // an invalid callbackId and passes it even if no callbacks were given.
            callbackId = 'INVALID';
        } else {
            // FORMAT TWO
            splitCommand = arguments[0].split(".");
            action = splitCommand.pop();
            service = splitCommand.join(".");
            actionArgs = Array.prototype.splice.call(arguments, 1);
        }
        
        // Start building the command object.
        var command = {
        className: service,
        methodName: action,
        arguments: []
        };
        
        // Register the callbacks and add the callbackId to the positional
        // arguments if given.
        if (successCallback || failCallback) {
            callbackId = service + Cordova.callbackId++;
            Cordova.callbacks[callbackId] = 
            {success:successCallback, fail:failCallback};
        }
        if (callbackId != null) {
            command.arguments.push(callbackId);
        }
        
        for (var i = 0; i < actionArgs.length; ++i) {
            var arg = actionArgs[i];
            if (arg == undefined || arg == null) {
                continue;
            } else if (typeof(arg) == 'object') {
                command.options = arg;
            } else {
                command.arguments.push(arg);
            }
        }
        
        // Stringify and queue the command. We stringify to command now to
        // effectively clone the command arguments in case they are mutated before
        // the command is executed.
        Cordova.commandQueue.push(JSON.stringify(command));
        
        // If the queue length is 1, then that means it was empty before we queued
        // the given command, so let the native side know that we have some
        // commands to execute, unless the queue is currently being flushed, in
        // which case the command will be picked up without notification.
        if (Cordova.commandQueue.length == 1 && !Cordova.commandQueueFlushing) {
            if (!Cordova.gapBridge) {
                Cordova.gapBridge = Cordova.createGapBridge();
            }
            
            Cordova.gapBridge.src = "gap://ready";
        }
    };
    
    /**
     * Called by native code to retrieve all queued commands and clear the queue.
     */
    Cordova.getAndClearQueuedCommands = function() {
        json = JSON.stringify(Cordova.commandQueue);
        Cordova.commandQueue = [];
        return json;
    };
    
    /**
     * Called by native code when returning successful result from an action.
     *
     * @param callbackId
     * @param args
     *        args.status - Cordova.callbackStatus
     *        args.message - return value
     *        args.keepCallback - 0 to remove callback, 1 to keep callback in Cordova.callbacks[]
     */
    Cordova.callbackSuccess = function(callbackId, args) {
        if (Cordova.callbacks[callbackId]) {
            
            // If result is to be sent to callback
            if (args.status == Cordova.callbackStatus.OK) {
                try {
                    if (Cordova.callbacks[callbackId].success) {
                        Cordova.callbacks[callbackId].success(args.message);
                    }
                }
                catch (e) {
                    console.log("Error in success callback: "+callbackId+" = "+e);
                }
            }
            
            // Clear callback if not expecting any more results
            if (!args.keepCallback) {
                delete Cordova.callbacks[callbackId];
            }
        }
    };
    
    /**
     * Called by native code when returning error result from an action.
     *
     * @param callbackId
     * @param args
     */
    Cordova.callbackError = function(callbackId, args) {
        if (Cordova.callbacks[callbackId]) {
            try {
                if (Cordova.callbacks[callbackId].fail) {
                    Cordova.callbacks[callbackId].fail(args.message);
                }
            }
            catch (e) {
                console.log("Error in error callback: "+callbackId+" = "+e);
            }
            
            // Clear callback if not expecting any more results
            if (!args.keepCallback) {
                delete Cordova.callbacks[callbackId];
            }
        }
    };
    
    
    /**
     * Does a deep clone of the object.
     *
     * @param obj
     * @return
     */
    Cordova.clone = function(obj) {
        if(!obj) { 
            return obj;
        }
        
        if(obj instanceof Array){
            var retVal = new Array();
            for(var i = 0; i < obj.length; ++i){
                retVal.push(Cordova.clone(obj[i]));
            }
            return retVal;
        }
        
        if (obj instanceof Function) {
            return obj;
        }
        
        if(!(obj instanceof Object)){
            return obj;
        }
        
        if (obj instanceof Date) {
            return obj;
        }
        
        retVal = new Object();
        for(i in obj){
            if(!(i in retVal) || retVal[i] != obj[i]) {
                retVal[i] = Cordova.clone(obj[i]);
            }
        }
        return retVal;
    };
    
    // Intercept calls to document.addEventListener 
    Cordova.m_document_addEventListener = document.addEventListener;
    
    // Intercept calls to window.addEventListener
    Cordova.m_window_addEventListener = window.addEventListener;
    
    /**
     * Add a custom window event handler.
     *
     * @param {String} event            The event name that callback handles
     * @param {Function} callback       The event handler
     */
    Cordova.addWindowEventHandler = function(event, callback) {
        Cordova.windowEventHandler[event] = callback;
    };
    
    /**
     * Add a custom document event handler.
     *
     * @param {String} event            The event name that callback handles
     * @param {Function} callback       The event handler
     */
    Cordova.addDocumentEventHandler = function(event, callback) {
        Cordova.documentEventHandler[event] = callback;
    };
    
    /**
     * Intercept adding document event listeners and handle our own
     *
     * @param {Object} evt
     * @param {Function} handler
     * @param capture
     */
    document.addEventListener = function(evt, handler, capture) {
        var e = evt.toLowerCase();
        
        // If subscribing to an event that is handled by a plugin
        if (typeof Cordova.documentEventHandler[e] !== "undefined") {
            if (Cordova.documentEventHandler[e](e, handler, true)) {
                return; // Stop default behavior
            }
        }
        
        Cordova.m_document_addEventListener.call(document, evt, handler, capture); 
    };
    
    /**
     * Intercept adding window event listeners and handle our own
     *
     * @param {Object} evt
     * @param {Function} handler
     * @param capture
     */
    window.addEventListener = function(evt, handler, capture) {
        var e = evt.toLowerCase();
        
        // If subscribing to an event that is handled by a plugin
        if (typeof Cordova.windowEventHandler[e] !== "undefined") {
            if (Cordova.windowEventHandler[e](e, handler, true)) {
                return; // Stop default behavior
            }
        }
        
        Cordova.m_window_addEventListener.call(window, evt, handler, capture);
    };
    
    // Intercept calls to document.removeEventListener and watch for events that
    // are generated by Cordova native code
    Cordova.m_document_removeEventListener = document.removeEventListener;
    
    // Intercept calls to window.removeEventListener
    Cordova.m_window_removeEventListener = window.removeEventListener;
    
    /**
     * Intercept removing document event listeners and handle our own
     *
     * @param {Object} evt
     * @param {Function} handler
     * @param capture
     */
    document.removeEventListener = function(evt, handler, capture) {
        var e = evt.toLowerCase();
        
        // If unsubcribing from an event that is handled by a plugin
        if (typeof Cordova.documentEventHandler[e] !== "undefined") {
            if (Cordova.documentEventHandler[e](e, handler, false)) {
                return; // Stop default behavior
            }
        }
        
        Cordova.m_document_removeEventListener.call(document, evt, handler, capture);
    };
    
    /**
     * Intercept removing window event listeners and handle our own
     *
     * @param {Object} evt
     * @param {Function} handler
     * @param capture
     */
    window.removeEventListener = function(evt, handler, capture) {
        var e = evt.toLowerCase();
        
        // If unsubcribing from an event that is handled by a plugin
        if (typeof Cordova.windowEventHandler[e] !== "undefined") {
            if (Cordova.windowEventHandler[e](e, handler, false)) {
                return; // Stop default behavior
            }
        }
        
        Cordova.m_window_removeEventListener.call(window, evt, handler, capture);
    };
    
    /**
     * Method to fire document event
     *
     * @param {String} type             The event type to fire
     * @param {Object} data             Data to send with event
     */
    Cordova.fireDocumentEvent = function(type, data) {
        var e = document.createEvent('Events');
        e.initEvent(type);
        if (data) {
            for (var i in data) {
                e[i] = data[i];
            }
        }
        document.dispatchEvent(e);
    };
    
    /**
     * Method to fire window event
     *
     * @param {String} type             The event type to fire
     * @param {Object} data             Data to send with event
     */
    Cordova.fireWindowEvent = function(type, data) {
        var e = document.createEvent('Events');
        e.initEvent(type);
        if (data) {
            for (var i in data) {
                e[i] = data[i];
            }
        }
        window.dispatchEvent(e);
    };
    
    /**
     * Method to fire event from native code
     * Leaving this generic version to handle problems with iOS 3.x. Is currently used by orientation and battery events
     * Remove when iOS 3.x no longer supported and call fireWindowEvent or fireDocumentEvent directly
     */
    Cordova.fireEvent = function(type, target, data) {
        var e = document.createEvent('Events');
        e.initEvent(type);
        if (data) {
            for (var i in data) {
                e[i] = data[i];
            }
        }
        target = target || document;
        if (target.dispatchEvent === undefined) { // ie window.dispatchEvent is undefined in iOS 3.x
            target = document;
        } 
        
        target.dispatchEvent(e);
    };
    /**
     * Create a UUID
     *
     * @return
     */
    Cordova.createUUID = function() {
        return Cordova.UUIDcreatePart(4) + '-' +
        Cordova.UUIDcreatePart(2) + '-' +
        Cordova.UUIDcreatePart(2) + '-' +
        Cordova.UUIDcreatePart(2) + '-' +
        Cordova.UUIDcreatePart(6);
    };
    
    Cordova.UUIDcreatePart = function(length) {
        var uuidpart = "";
        for (var i=0; i<length; i++) {
            var uuidchar = parseInt((Math.random() * 256)).toString(16);
            if (uuidchar.length == 1) {
                uuidchar = "0" + uuidchar;
            }
            uuidpart += uuidchar;
        }
        return uuidpart;
    };
};

if (!Cordova.hasResource("device"))
	Cordova.addResource("device");

/**
 * this represents the mobile device, and provides properties for inspecting the model, version, UUID of the
 * phone, etc.
 * @constructor
 */
Device = function() 
{
    this.platform = null;
    this.version  = null;
    this.name     = null;
    this.uuid     = null;
    try 
	{      
		this.platform = DeviceInfo.platform;
		this.version  = DeviceInfo.version;
		this.name     = DeviceInfo.name;
		this.uuid     = DeviceInfo.uuid;

    } 
	catch(e) 
	{
        // TODO: 
    }
	this.available = Cordova.available = this.uuid != null;
};

Cordova.addConstructor(function() {
	if (typeof navigator.device === "undefined") {
    	navigator.device = window.device = new Device();
	}
});

if (!Cordova.hasResource("debugconsole")) {
	Cordova.addResource("debugconsole");
	
/**
 * This class provides access to the debugging console.
 * @constructor
 */
var DebugConsole = function() {
    this.winConsole = window.console;
    this.logLevel = DebugConsole.INFO_LEVEL;
}

// from most verbose, to least verbose
DebugConsole.ALL_LEVEL    = 1; // same as first level
DebugConsole.INFO_LEVEL   = 1;
DebugConsole.WARN_LEVEL   = 2;
DebugConsole.ERROR_LEVEL  = 4;
DebugConsole.NONE_LEVEL   = 8;
													
DebugConsole.prototype.setLevel = function(level) {
    this.logLevel = level;
};

/**
 * Utility function for rendering and indenting strings, or serializing
 * objects to a string capable of being printed to the console.
 * @param {Object|String} message The string or object to convert to an indented string
 * @private
 */
DebugConsole.prototype.processMessage = function(message, maxDepth) {
	if (maxDepth === undefined) maxDepth = 0;
    if (typeof(message) != 'object') {
        return (this.isDeprecated ? "WARNING: debug object is deprecated, please use console object \n" + message : message);
    } else {
        /**
         * @function
         * @ignore
         */
        function indent(str) {
            return str.replace(/^/mg, "    ");
        }
        /**
         * @function
         * @ignore
         */
        function makeStructured(obj, depth) {
            var str = "";
            for (var i in obj) {
                try {
                    if (typeof(obj[i]) == 'object' && depth < maxDepth) {
                        str += i + ":\n" + indent(makeStructured(obj[i])) + "\n";
                    } else {
                        str += i + " = " + indent(String(obj[i])).replace(/^    /, "") + "\n";
                    }
                } catch(e) {
                    str += i + " = EXCEPTION: " + e.message + "\n";
                }
            }
            return str;
        }
        
        return ("Object:\n" + makeStructured(message, maxDepth));
    }
};

/**
 * Print a normal log message to the console
 * @param {Object|String} message Message or object to print to the console
 */
DebugConsole.prototype.log = function(message, maxDepth) {
    if (Cordova.available && this.logLevel <= DebugConsole.INFO_LEVEL)
        Cordova.exec(null, null, 'org.apache.cordova.debugconsole', 'log',
            [ this.processMessage(message, maxDepth), { logLevel: 'INFO' } ]
        );
    else
        this.winConsole.log(message);
};

/**
 * Print a warning message to the console
 * @param {Object|String} message Message or object to print to the console
 */
DebugConsole.prototype.warn = function(message, maxDepth) {
    if (Cordova.available && this.logLevel <= DebugConsole.WARN_LEVEL)
    	Cordova.exec(null, null, 'org.apache.cordova.debugconsole', 'log',
            [ this.processMessage(message, maxDepth), { logLevel: 'WARN' } ]
        );
    else
        this.winConsole.error(message);
};

/**
 * Print an error message to the console
 * @param {Object|String} message Message or object to print to the console
 */
DebugConsole.prototype.error = function(message, maxDepth) {
    if (Cordova.available && this.logLevel <= DebugConsole.ERROR_LEVEL)
		Cordova.exec(null, null, 'org.apache.cordova.debugconsole', 'log',
            [ this.processMessage(message, maxDepth), { logLevel: 'ERROR' } ]
        );
    else
        this.winConsole.error(message);
};

Cordova.addConstructor(function() {
    window.console = new DebugConsole();
});
};

/*     w3bridge v1.0.0 */
/*
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
 
//
//  WebBridge
//
//  Created by KH Kim on 12. 3. 13..
//  Copyright (c) 2012년 hh963103@naver.com. All rights reserved.
//

WebBridge = function(){};

Cordova.addConstructor(function(){
    if (typeof navigator.bridge == "undefined") navigator.bridge = new WebBridge();
});

//
//  View
//
//  Created by KH Kim on 12. 3. 13..
//  Copyright (c) 2012년 hh963103@naver.com. All rights reserved.
//

if (!Cordova.hasResource("view"))
	Cordova.addResource("view");

View = function(){};

View.prototype.close = function(animated) {
    if (Cordova.isValidPlatform()) {
    	var _animated = animated == undefined || animated == null ? 1 : animated;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "close", [_animated]);
    }
};
View.prototype.hideActivityIndicatorView = function() {
	if (Cordova.isValidPlatform()) {
        Cordova.exec(null, null, "org.apache.w3bridge.view", "hideActivityIndicatorView", []);
  }
};
View.prototype.open = function(url, method, options) {
  if (method == "browser") {
		navigator.bridge.view.openBrowser(url, options);
	} else {
  	var _options = {scrollEnabled: 1, hidesBottomBarWhenPushed: 0, landscape: 0, leftBarButtonItemText: "null", modalTransitionStyle: 0, title: "null", useReloadDisplay: 1};
  	for (var name in options)
  		_options[name] = options[name];
  
  	if (method == "push") {
  		navigator.bridge.view.pushWithURL(url, _options.scrollEnabled, _options.hidesBottomBarWhenPushed, _options.landscape, _options.leftBarButtonItemText, _options.title, _options.useReloadDisplay);
  	} else if (method == "pop") {
  		navigator.bridge.view.popWithURL(url, _options.scrollEnabled, _options.landscape, _options.leftBarButtonItemText, _options.modalTransitionStyle, _options.title, _options.useReloadDisplay);
  	}
	}
};
View.prototype.openBrowser = function(url, options) {
    if (Cordova.isValidPlatform()) {
        Cordova.exec(null, null, "org.apache.w3bridge.view", "openBrowser", [url, options]);
    } else {
    	window.location.href = url;
    }
};
View.prototype.openLayerBridgeWebView = function(url, options) {
    if (Cordova.isValidPlatform()) {
        Cordova.exec(null, null, "org.apache.w3bridge.view", "openLayerBridgeWebView", [url, options]);
    }
};
View.prototype.pushWithURL = function(url, scrollEnabled, hidesBottomBarWhenPushed, landscape, leftBarButtonItemText, title, useReloadDisplay) {
    if (Cordova.isValidPlatform()) {
    	var _scrollEnabled = scrollEnabled == undefined || scrollEnabled == null ? 1 : scrollEnabled;
    	var _hidesBottomBarWhenPushed = hidesBottomBarWhenPushed == undefined || hidesBottomBarWhenPushed == null ? 0 : hidesBottomBarWhenPushed;
    	var _landscape = landscape == undefined || landscape == null ? 0 : landscape;
    	var _useReloadDisplay = useReloadDisplay == undefined || useReloadDisplay == null ? 1 : useReloadDisplay;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "pushWithURL",
        	[url, _scrollEnabled, _hidesBottomBarWhenPushed, _landscape, leftBarButtonItemText, title, _useReloadDisplay]);
    } else {
    	window.location.href = url;
    }
};
View.prototype.popToRootView = function(animated) {
    if (Cordova.isValidPlatform()) {
    	var _animated = animated == undefined || animated == null ? 1 : animated;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "popToRootView", [_animated]);
    }
};
View.prototype.popWithURL = function(url, scrollEnabled, landscape, leftBarButtonItemText, modalTransitionStyle, title, useReloadDisplay) {
    if (Cordova.isValidPlatform()) {
    	var _scrollEnabled = scrollEnabled == undefined || scrollEnabled == null ? 1 : scrollEnabled;
    	var _landscape = landscape == undefined || landscape == null ? 0 : landscape;
    	var _useReloadDisplay = useReloadDisplay == undefined || useReloadDisplay == null ? 1 : useReloadDisplay;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "popWithURL",
        	[url, _scrollEnabled, _landscape, leftBarButtonItemText, modalTransitionStyle, title, _useReloadDisplay]);
    } else {
    	window.location.href = url;
    }
};
View.prototype.setProperties = function(properties) {
	if (Cordova.isValidPlatform()) {
        Cordova.exec(null, null, "org.apache.w3bridge.view", "setProperty", [properties]);
	}
};
View.prototype.setSize = function(width, height) {
	if (Cordova.isValidPlatform()) {
		var w = width == undefined || height == null ? "" : width;
		var h = height == undefined || height == null ? "" : height;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "setSize", [w, h]);
	}
};
View.prototype.setTitle = function(title) {
	if (Cordova.isValidPlatform()) {
		var _title = title == undefined || title == null ? "" : title;
        Cordova.exec(null, null, "org.apache.w3bridge.view", "setTitle", [_title]);
	}
};
View.prototype.showActivityIndicatorView = function() {
	if (Cordova.isValidPlatform()) {
        Cordova.exec(null, null, "org.apache.w3bridge.view", "showActivityIndicatorView", []);
  }
};

Cordova.addConstructor(function(){
    if (typeof navigator.bridge.view == "undefined") navigator.bridge.view = new View();
});

Cordova.addConstructor(function(){
    if (typeof navigator.bridge.modules == "undefined") navigator.bridge.modules = new GModules();
});

//
//  Notification
//
//  Created by KH Kim on 12. 8. 2..
//  Modified by KH Kim on 13. 10. 17..
//  Copyright (c) 2012년 hh963103@naver.com. All rights reserved.
//

if (!Cordova.hasResource("notification"))
	Cordova.addResource("notification");

Notification = function(){};

Notification.prototype.addObserver = function(name, callBack, uniqueKey) {
	var _uniqueKey = uniqueKey == undefined || uniqueKey == null ? "" : uniqueKey;
	Cordova.exec(null, null, "org.apache.w3bridge.notification", "addObserver", [name, callBack, _uniqueKey]);
};

Notification.prototype.postNotification = function(name, data, uniqueKey) {
	var _uniqueKey = uniqueKey == undefined || uniqueKey == null ? "" : uniqueKey;
  var _data = data;
	if (_data) {
	  _data.uniqueKey = _uniqueKey;
	} else {
	  _data = {uniqueKey: _uniqueKey};  
	}
	Cordova.exec(null, null, "org.apache.w3bridge.notification", "postNotification", [name, _uniqueKey, _data]);
};

Notification.prototype.removeObserver = function(name, callBack, uniqueKey) {
	var _uniqueKey = uniqueKey == undefined || uniqueKey == null ? "" : uniqueKey;
	Cordova.exec(null, null, "org.apache.w3bridge.notification", "removeObserver", [name, callBack, _uniqueKey]);
};

Cordova.addConstructor(function(){
    if (typeof navigator.bridge.notification == "undefined") navigator.bridge.notification = new Notification();
});

//
//  ExternalInterface
//
//  Created by KH Kim on 13. 12. 13..
//  Copyright (c) 2013년 hh963103@naver.com. All rights reserved.
//

if (!Cordova.hasResource("externalInterface"))
	Cordova.addResource("externalInterface");

ExternalInterface = function(){};

ExternalInterface.prototype.call = function(name, options, success, error) {
	Cordova.exec(success, error, "org.apache.w3bridge.externalInterface", "call", [name, options]);
};

ExternalInterface.prototype.addCallback = function(name, callback) {
	Cordova.exec(callback, null, "org.apache.w3bridge.externalInterface", "addCallback", [name]);
};

Cordova.addConstructor(function(){
    if (typeof navigator.bridge.externalInterface == "undefined") navigator.bridge.externalInterface = new ExternalInterface();
});