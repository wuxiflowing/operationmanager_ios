//
//  JKScanVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKScanVC.h"
#import <AVFoundation/AVFoundation.h>

@interface JKScanVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIView *borderView;
@end

@implementation JKScanVC

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = kBlackColor;
    [self setUpCamera];
    [self createPreview];
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScanning];
}

- (void)createBtnsUI {
    
    UILabel *tipsLb = [[UILabel alloc] init];
    tipsLb.text = @"将二维码放入框内，可自动扫描";
    tipsLb.textColor = RGBHexAlpha(0xeeeeee, 0.8);
    tipsLb.textAlignment = NSTextAlignmentCenter;
    tipsLb.font = JKFont(12);
    [self.view addSubview:tipsLb];
    [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borderView.mas_bottom).offset(SCALE_SIZE(20));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    //闪光灯
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setImage:[UIImage imageNamed:@"ic_flash_off"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage imageNamed:@"ic_flash_on"] forState:UIControlStateSelected];
    flashBtn.contentMode = UIViewContentModeScaleAspectFit;
    [flashBtn addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(tipsLb.mas_bottom).offset(SCALE_SIZE(40));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark -- 创建扫描框
- (void)createPreview {
    CGFloat previewW = SCREEN_WIDTH * 0.65;
    CGFloat padding = 10;
    CGFloat labelH = 20;
    CGFloat cornerW = 26;
    CGFloat marginX = (SCREEN_WIDTH - previewW) * 0.5;
    CGFloat marginTopY = (SCREEN_HEIGHT - previewW - padding - labelH) * 0.2;
    CGFloat marginBottomY = (SCREEN_HEIGHT - previewW - padding - labelH) * 0.8;
    
    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginTopY + previewW) * i + SafeAreaTopHeight, SCREEN_WIDTH, marginTopY + (padding + labelH) * i)];
        if (i == 2 || i == 3) {
            cover.frame = CGRectMake((marginX + previewW) * (i - 2), marginTopY + SafeAreaTopHeight, marginX, previewW);
        } else if (i == 1) {
            cover.frame = CGRectMake(0, (marginTopY + previewW) * i + SafeAreaTopHeight, SCREEN_WIDTH, marginBottomY + (padding + labelH) * i);
        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    
    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginTopY + SafeAreaTopHeight, previewW, previewW)];
    [self.view addSubview:scanView];

    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, previewW, 2)];
    [self drawLineForImageView:line];
    [scanView addSubview:line];
    self.line = line;

    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, previewW, previewW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];
    self.borderView = borderView;
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (previewW - cornerW) * (i % 2);
        CGFloat imgViewY = (previewW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    [self createBtnsUI];
}

//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView {
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([kThemeColor CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([kWhiteColor CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//绘制角图片
- (void)drawImageForImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [kThemeColor CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark -- 配置摄像头信息
- (void)setUpCamera {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //初始化输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        //初始化输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:input]) [_session addInput:input];
        if ([_session canAddOutput:output]) [_session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view.layer insertSublayer:_preview atIndex:0];
            [_session startRunning];
        });
    });
}

- (void)addTimer {
    self.distance = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    if (_distance++ > SCREEN_WIDTH * 0.65) self.distance = 0;
    self.line.frame = CGRectMake(0, _distance, SCREEN_WIDTH * 0.65, 2);
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)stopScanning {
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [self removeTimer];
}

#pragma mark -- 闪光灯点击事件
- (void)flashBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.device lockForConfiguration:nil];
    if (btn.selected) {
        [self.device setTorchMode:AVCaptureTorchModeOn];
    } else {
        [self.device setTorchMode:AVCaptureTorchModeOff];
    }
    [self.device unlockForConfiguration];
}

#pragma mark -- 相册点击事件
- (void)albumBtnClick:(UIButton *)btn {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取相册图片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //识别图片
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        //识别结果
        if (features.count > 0) {
            [YJProgressHUD showMessage:[[features firstObject] messageString] inView:self.view afterDelayTime:2];
            
        }else{
            [YJProgressHUD showMessage:@"没有识别到二维码或条形码" inView:self.view afterDelayTime:2];
        }
    }];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //扫描完成
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self stopScanning];
        //显示结果
        if ([_delegate respondsToSelector:@selector(showDeviceId:)]) {
            [_delegate showDeviceId:[[metadataObjects firstObject] stringValue]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 关闭点击事件
- (void)closeBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

