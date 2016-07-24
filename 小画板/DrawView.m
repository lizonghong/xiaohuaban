//
//  DrawView.m
//  小画板
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DrawView.h"
#import "LZHBezierPath.h"
@interface DrawView()

@property (strong, nonatomic) LZHBezierPath *berzierPath;

@property (strong, nonatomic) NSMutableArray *pathArray;

@property (assign, nonatomic) NSInteger count;


@end


@implementation DrawView
#pragma mark
#pragma mark -懒加载数组
- (NSMutableArray *)pathArray{
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }



    return _pathArray;
}

#pragma mark
#pragma mark - 界面初始化,线宽为1
- (void)awakeFromNib{
    _lineWidth = 1;

}

#pragma mark
#pragma mark - 实现回退
- (void)back {
    
    
    // 移除在数组中最后一个路径
    [self.pathArray removeLastObject];
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark - 清屏
- (void)clear {
    
    [self.pathArray removeAllObjects];
    
    
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark - 橡皮擦
- (void)eraser {
    
    _lineColor = self.backgroundColor;
    
}

#pragma mark
#pragma mark - 绘制图片
- (void)setImage:(UIImage *)image {
    _image = image;
    
    // 把image 当成一个单独的路径
    
    // 创建一个 路径对象
    LZHBezierPath *bezierPath = [LZHBezierPath bezierPath];
    
    bezierPath.image = image;
    
    // 把路径添加到数组中
    [self.pathArray addObject:bezierPath];
    
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark - 开始触摸

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    LZHBezierPath *bezierPath = [LZHBezierPath bezierPath];
    self.berzierPath = bezierPath;
    [bezierPath moveToPoint:point];
    //设置线宽
    bezierPath.lineWidth = _lineWidth;
    
    //设置路径的颜色
    bezierPath.lineColor = _lineColor;
    //把路径添加到数组中
    [self.pathArray addObject:bezierPath];



    
}
#pragma mark
#pragma mark - 手指移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point  = [touch locationInView:touch.view];
    [self.berzierPath addLineToPoint:point];
    //重绘
    [self setNeedsDisplay];
    
}
#pragma mark
#pragma mark - 绘制线条
- (void)drawRect:(CGRect)rect{
    for (LZHBezierPath *path in self.pathArray) {
        [path.lineColor set];
        [path stroke];
    }



}


@end
