//
//  GraphicsLayout.h
//  PSUIKit
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

#import <UIKit/UIKit.h>

#ifndef GUIKit_GraphicsLayout_h
#define GUIKit_GraphicsLayout_h

typedef struct {
    unsigned int left;
    unsigned int top;
    unsigned int right;
    unsigned int bottom;
} CGPadding;

CGPadding CGPaddingMake(unsigned int left, unsigned int top, unsigned int right, unsigned int bottom);
CGPadding CGPaddingMakeHorizontal(unsigned int left, unsigned int right);
CGPadding CGPaddingMakeVertical(unsigned int top, unsigned int bottom);
BOOL CGPaddingEquals(CGPadding padding1, CGPadding padding2);
BOOL CGPaddingZero(CGPadding padding);

#endif

@interface GraphicsLayout : NSObject
+ (void)fitByText:(UILabel *)target;
+ (void)fitByText:(UILabel *)target maxSize:(CGSize)maxSize;
+ (void)heightFitByText:(UILabel *)target;
+ (void)heightFitByText:(UILabel *)target maxWidth:(CGFloat)maxWidth;
+ (void)widthFitByText:(UILabel *)target;
+ (void)widthFitByText:(UILabel *)target maxHeight:(CGFloat)maxHeight;
+ (CGSize)heightFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxWidth:(CGFloat)maxWidth;
+ (CGSize)widthFitSizeWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxHeight:(CGFloat)maxHeight;
@end
