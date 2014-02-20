'w3bridge' is iOS framework bridges between native web view and HTML javascript.
It provides bridge web view that make the web page looks like native view.
This framework control the native web view and included web page each other.

## Usage
### Implementation of native web view 
#### Inheritance
```objective-c
#import <UIKit/UIKit.h>
#import <w3bridge/w3bridge.h>

@interface ViewController : UIBridgeWebViewController
@end

#import "ViewController.h"

#define URLOfSample @"http://pisces.jdsn.net/w3bridgeDemo/html/w3bridge-sample-main.html"

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.destination = [NSURL URLWithString:URLOfSample];
}
@end
```
#### Composition
```objective-c
#import <UIKit/UIKit.h>
#import <w3bridge/w3bridge.h>

@interface ViewController : UIViewController
@end

#import "ViewController.h"

#define URLOfSample @"http://pisces.jdsn.net/w3bridgeDemo/html/w3bridge-sample-main.html"

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBridgeWebViewController *controller = [[UIBridgeWebViewController alloc] init];
    controller.destination = [NSURL URLWithString:URLOfSample];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
```
### Implementation of html web page
#### w3bridge-sample-main.html
```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="initial-scale=1,maximum-scale=2,user-scalable=no" />
    <title>w3bridge Sample</title>
    
    <style type="text/css">
    	body {padding:0;margin:0;width:100%;height:100%;}
    	ul {list-style:none;padding:0 0 20px 0;margin:0;}
    	ul li {margin-left:20px;}
    </style>
</head>

<body onload="onBodyLoad();">
<ul>
	<li><button onclick="openAsPush();" style="width:120px;height:30px;margin-top:30px;">open as push</button></li>
	<li><button onclick="openAsPop();" style="width:120px;height:30px;margin-top:30px;">open as pop</button></li>
	<li><button onclick="postNotification();" style="width:120px;height:30px;margin-top:30px;">post notification</button></li>
	<li><button onclick="multiplePopUpView();" style="width:120px;height:30px;margin-top:30px;">multiple popup view</button></li>
	<li><button onclick="openLayerBridgeWebView();" style="width:120px;height:30px;margin-top:30px;">open layer bridge webview</button></li>
</ul>
		
<script type="text/javascript" src="http://pisces.jdsn.net/w3bridgeDemo/w3bridge-1.0.0.min.js"></script>
<script type="text/javascript">
    
    var urlOfP1 = "http://pisces.jdsn.net/w3bridgeDemo/html/w3bridge-sample-p1.html";
    var urlOfLayer = "http://pisces.jdsn.net/w3bridgeDemo/html/w3bridge-sample-layer.html";
	
	//--------------------------------------------------------------------------
	// Methods
	//--------------------------------------------------------------------------
    
    function multiplePopUpView(){
    	navigator.bridge.view.open(urlOfP1, "pop");
    }
    
    function openAsPush(){
    	navigator.bridge.view.open(urlOfP1, "push", {closeEnabled: 0});
    }
    
    function openAsPop(){
    	navigator.bridge.view.open(urlOfP1, "pop");
    }
    
    function openLayerBridgeWebView(){
    	navigator.bridge.view.openLayerBridgeWebView(urlOfLayer, {width: 300, height: 400, modal: 1});
    }
    
    function postNotification(){
    	navigator.bridge.notification.postNotification("init", {});
    }

	//--------------------------------------------------------------------------
	//  Event handlers
	//--------------------------------------------------------------------------
	
	function onBodyLoad(){
		document.addEventListener("deviceready", onDeviceReady, false);
    }

    function onDeviceReady(){
    	debugconsoleTest();
    	externalInterfaceCallTest();
    	externalInterfaceAddCallbackTest();
    	notificationTest();
    }

	//--------------------------------------------------------------------------
	//  Test Functions
	//--------------------------------------------------------------------------
	
	function debugconsoleTest(){
    	console.log(DeviceInfo);
	}

	function externalInterfaceCallTest(){
    	navigator.bridge.externalInterface.call("alert", {message: "mesage", title: "ext call"}, function(result){
    		console.log("result -> " + result);
    	}, function(error){
    		console.log("error -> " + error);
    	});
    	

    	navigator.bridge.externalInterface.call("alert", {message: "mesage", title: "ext call"}, successHandler, function(error){
    		console.log("error -> " + error);
    	});
	}
	
	function successHandler(result)
	{
		console.log("successHandler");
	}
	
	function externalInterfaceAddCallbackTest(){
		navigator.bridge.externalInterface.addCallback("rightBarButtonClick", function(result){
    		console.log("called rightBarButtonClick callback function");
		});
	}

	function notificationTest(){
    	navigator.bridge.notification.addObserver("select", "selectHandler");
    	navigator.bridge.notification.addObserver("viewWillAppear", "viewWillAppear");
    	navigator.bridge.notification.addObserver("viewWillDisappear", "viewWillDisappear");
	}
  
	//--------------------------------------------------------------------------
	//  Callback Functions
	//--------------------------------------------------------------------------

    function selectHandler(){
    	console.log("selectHandler");
    }
    
    function viewWillAppear(){
    	console.log("viewWillAppear");
    }

    function viewWillDisappear(){
    	console.log("viewWillDisappear");
    }
</script>
</body>
</html>
```
#### Result
<p align="left" >
<img src="https://raw.github.com/pisces/w3bridge/master/w3bridgeDemo/screenshots/screenshot01.png" width="320" height="568" border="1"/>
<img src="https://raw.github.com/pisces/w3bridge/master/w3bridgeDemo/screenshots/screenshot05.png" border="1"/>
</p>
