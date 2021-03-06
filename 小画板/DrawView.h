//
//  DrawView.h
//  小画板
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (nonatomic, strong) UIImage *image;
- (void)back;

- (void)clear;

- (void)eraser;
@end
