//
//  PhotoView.h
//  小画板
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PhotoView : UIView


@property (nonatomic, strong) UIImage *image;


@property (nonatomic, copy) void(^tempBlock)(UIImage *);

@end
