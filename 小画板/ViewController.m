//
//  ViewController.m
//  小画板
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "PhotoView.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark
#pragma mark - 设置返回事件
- (IBAction)back:(id)sender {
    [_drawView back];
}

#pragma mark
#pragma mark - 设置清屏事件
- (IBAction)clear:(id)sender {
    [_drawView clear];
}

#pragma mark
#pragma mark -设置橡皮事件
- (IBAction)eraser:(id)sender {
    [_drawView eraser];
}

#pragma mark
#pragma mark - 设置相片事件
- (IBAction)photos:(id)sender {
    
    // 弹出相册选择器
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    // 资源类型
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 设置 控制器成为选择器的代理
    pickerController.delegate = self;
    
    // 展示 相册选择器
    [self presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark
#pragma mark - 照片选择器的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加 photoView
    PhotoView *photoView = [[PhotoView alloc] initWithFrame:_drawView.frame];
    
    photoView.image = image;
    
    __weak PhotoView *weakPhotoView = photoView;
    
    // 为tempBlock 赋值
    photoView.tempBlock = ^(UIImage *image){
        
        // 把要绘制的图片传递给 drawView进行绘制
        _drawView.image = image;
        
        
        // 把 photoView 移除掉
        // 引用外部变量的时候, 会做一次copy, 也就是对外部的对象有一个强引用
        [weakPhotoView removeFromSuperview];
    };
    
    // 添加photoView 到 控制器的view上
    [self.view addSubview:photoView];
    
    // dismiss imagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark
#pragma mark - 设置保存事件

- (IBAction)save:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    
    // 获取当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // 把_drawView的layer 渲染到当前的上下文中
    [_drawView.layer renderInContext:context];
    
    // 从当前上下文中获取 图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    
    // 保存图片到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

#pragma mark
#pragma mark - 监听图片保存
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    
    if (!error) {
        
        NSLog(@"保存图片成功");
    }
}

#pragma mark
#pragma mark - 设置监听事件
- (IBAction)valueChanged:(UISlider *)sender {
    _drawView.lineWidth = sender.value;
    NSLog(@"%f",sender.value);
}

#pragma mark
#pragma mark - 设置颜色按钮事件
- (IBAction)colorButton:(UISlider *)sender {
    
    _drawView.lineColor = sender.backgroundColor;
}

@end
