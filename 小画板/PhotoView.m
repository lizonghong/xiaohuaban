//
//  PhotoView.m
//  小画板
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark
#pragma mark - 设置界面
- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    self.imageView = imageView;
    
    [self addSubview:imageView];
    
    // 开启用户交互
    imageView.userInteractionEnabled = YES;
    
    
    // 旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    
    rotation.delegate = self;
    
    [imageView addGestureRecognizer:rotation];
    
    // 缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    
    [imageView addGestureRecognizer:pinch];
    // 拖拽
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    
    [imageView addGestureRecognizer:pan];
    
    // 长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [imageView addGestureRecognizer:longPress];
    
}

#pragma mark
#pragma mark - 旋转
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotation.rotation);
    
    rotation.rotation = 0;
}

#pragma mark
#pragma mark - 缩放
- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    
    pinch.scale = 1;
}

#pragma mark
#pragma mark - 拖拽
- (void)pan:(UIPanGestureRecognizer *)pan  {
    
    CGPoint trPoint = [pan translationInView:pan.view];
    
    _imageView.transform = CGAffineTransformTranslate(_imageView.transform, trPoint.x, trPoint.y);
    
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

#pragma mark
#pragma mark - 长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
   
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _imageView.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _imageView.alpha = 1;
                
            } completion:^(BOOL finished) {
                // 把当前的view 通过图片上下文转为 图片
                // 开启图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                // 获取当前的上下文
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                // 把当前view的layer 渲染到上下文中
                [self.layer renderInContext:context];
                
                
                // 从当前的上下文中获取图片吧
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                
                
                UIGraphicsEndImageContext();
                
                // photoView 要 传递消息, 就创建block, 然后进行调用
                // 如果tempBlock 有值, 就调用
                if (_tempBlock) {
                    _tempBlock(image);
                }
                
                
            }];
        }];
    }
    
}


#pragma mark
#pragma mark - 解决冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


#pragma mark
#pragma mark - 设置image
- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    _imageView.image = image;
}

//
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.bounds = CGRectMake(0, 0, _image.size.width, _image.size.height);
    
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}


@end
