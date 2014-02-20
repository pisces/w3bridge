'w3bridge' is iOS framework bridges between native web view and HTML javascript.
It provides bridge web view that make the web page looks like native view.
This framework control the native web view and included web page each other.

## Usage
### Implementation inheritance
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
### Implementation compose
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
