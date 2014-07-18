//
//  PSUIRefreshViewController.h
//  PSUIKit
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDate+PSUIKit.h"
#import "PSUIKit.h"

@interface PSUIRefreshViewController : UIViewController
@property (nonatomic) CGFloat reloadBoundsHeight;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) BOOL updating;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, weak) UIScrollView *target;
@property (nonatomic, readonly, strong) IBOutlet UIActivityIndicatorView *activitiIndicatorView;
@property (nonatomic, readonly, weak) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, readonly, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, readonly, weak) IBOutlet UILabel *updateLabel;
@end
