//
//  ViewController.m
//  dandanPanView
//
//  Created by 庞工 on 2017/9/18.
//  Copyright © 2017年 YMDream. All rights reserved.
//

#import "ViewController.h"
#import "RoundPanImageView.h"
#import "CoordinateGraphsView.h"


#define ROUNDSIZE 34

@interface ViewController ()<RoundPanViewDelegate>
{
    CoordinateGraphsView * coordinate;//坐标

    RoundPanImageView * _roundU1;
    RoundPanImageView * _roundU2;
    RoundPanImageView * _roundU3;
    RoundPanImageView * _roundD1;
    RoundPanImageView * _roundD2;
    RoundPanImageView * _roundD3;
    
    UIView * _upBaseView;//设定温度基准视图
    UIView * _downBaseView;
    
    UIView * _backView;//底图
    
    UIView * _roundViewU1;//可移动视图
    UIView * _roundViewU2;
    UILabel * _roundViewU3;
    UIView * _roundViewD1;
    UIView * _roundViewD2;
    UILabel * _roundViewD3;
    
    UILabel * _upSetLabel;
    UILabel * _downSetLabel;

    float _firstTime;
    float _secondTime;
    float _thirdTime;
    float _firstValue;
    float _secondValue;
    
    //图片数组
    NSMutableArray * _picObjArrU1;
    NSMutableArray * _picObjArrU2;
    NSMutableArray * _picObjArrD1;
    NSMutableArray * _picObjArrD2;
    
    //能耗标题
    UILabel * _noticeU1;
    UILabel * _noticeU2;
    UILabel * _noticeD1;
    UILabel * _noticeD2;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //测试数据
    _firstTime = 30;
    _secondTime = 60;
    _thirdTime = 90;
    _firstValue = 1;
    _secondValue = 2;
    
    _picObjArrU1 = [[NSMutableArray alloc] initWithCapacity:2];
    _picObjArrU2 = [[NSMutableArray alloc] initWithCapacity:5];
    _picObjArrD1 = [[NSMutableArray alloc] initWithCapacity:2];
    _picObjArrD2 = [[NSMutableArray alloc] initWithCapacity:5];

    [self layoutView];
    
    [self pakagePicArrWithCount:2 Obj:_picObjArrU1 ParentView:_roundViewU1];
    [self pakagePicArrWithCount:5 Obj:_picObjArrU2 ParentView:_roundViewU2];
    [self pakagePicArrWithCount:2 Obj:_picObjArrD1 ParentView:_roundViewD1];
    [self pakagePicArrWithCount:5 Obj:_picObjArrD2 ParentView:_roundViewD2];
    
    //更新树叶和能耗标题位置
    [self updataLeafAndTitleFrame];


    
}
- (void)pakagePicArrWithCount:(int)count Obj:(NSMutableArray*)arr ParentView:(UIView*)parentView{
    for (int i = 0; i<count+1; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"树叶.png"]];
        imageView.bounds = CGRectMake(0, 0, 29, 23);
        [parentView addSubview:imageView];
        [arr addObject:imageView];
    }
}
- (void)layoutView {
    
    //坐标
    coordinate = [[CoordinateGraphsView alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width-10, 400)];
    coordinate.unit_x = 10;
    coordinate.unit_y = 1;
    [self.view addSubview:coordinate];
    
    //控制点视图 -- 可拖动视图
    _roundU3 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(coordinate.width_x * (_thirdTime/10), coordinate.view_height_u - coordinate.width_y * _secondValue)Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundU3.delegate = self;
    _roundU3.border_right = coordinate.frame.size.width-ROUNDSIZE/2;
    _roundU3.border_top = _roundU3.center.y;
    _roundU3.border_bottom = _roundU3.center.y;
    _roundU3.step_x = coordinate.width_x;
    _roundU3.step_y = coordinate.width_y;
    _roundU3.x_value = _thirdTime;
    _roundU3.tag = 103;
    _roundU3.imagename = @"关机.png";
    _roundU3.backgroundColor = [UIColor lightGrayColor];
    _roundU3.valueLabel.hidden = YES;
    [coordinate addSubview:_roundU3];
    
    _roundD3 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(_roundU3.center.x, coordinate.view_top_d + coordinate.width_y * _secondValue)Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundD3.enable = NO;
    _roundD3.imagename = @"关机.png";
    _roundD3.backgroundColor = [UIColor lightGrayColor];
    _roundD3.valueLabel.hidden = YES;
    [coordinate addSubview:_roundD3];
    
    _roundU2 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(coordinate.width_x * (_secondTime/10), coordinate.view_height_u - coordinate.width_y * _secondValue) Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundU2.delegate = self;
    _roundU2.tag = 102;
    _roundU2.step_x = coordinate.width_x;
    _roundU2.step_y = coordinate.width_y;
    _roundU2.x_value = _secondTime;
    _roundU2.y_value = _secondValue;
    _roundU2.value = [NSString stringWithFormat:@"+%.0f",_secondValue];
    _roundU2.borderColor = @"053076";
    _roundU2.border_top = ROUNDSIZE/2;
    _roundU2.border_bottom = coordinate.view_height_u;
    [coordinate addSubview:_roundU2];
    
    _roundD2 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(_roundU2.center.x, coordinate.view_top_d + coordinate.width_y * _secondValue)Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundD2.enable = NO;
    _roundD2.value = [NSString stringWithFormat:@"-%.0f℃",_secondValue];
    _roundD2.borderColor = @"f59c00";
    [coordinate addSubview:_roundD2];

    _roundU1 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(coordinate.width_x * (_firstTime/10), coordinate.view_height_u - coordinate.width_y * _firstValue) Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundU1.delegate = self;
    _roundU1.tag = 101;
    _roundU1.step_x = coordinate.width_x;
    _roundU1.step_y = coordinate.width_y;
    _roundU1.x_value = _firstTime;
    _roundU1.y_value = _firstValue;
    _roundU1.value = [NSString stringWithFormat:@"+%.0f",_firstValue];
    _roundU1.borderColor = @"053076";
    _roundU1.border_top = coordinate.view_height_u - coordinate.width_y*2;
    _roundU1.border_bottom = coordinate.view_height_u;
    [coordinate addSubview:_roundU1];
    
    _roundD1 = [[RoundPanImageView alloc] initPanRoundViewWithCenter:CGPointMake(_roundU1.center.x, coordinate.view_top_d + coordinate.width_y * _firstValue)Size:CGSizeMake(ROUNDSIZE, ROUNDSIZE) DesView:coordinate];
    _roundD1.enable = NO;
    _roundD1.value = [NSString stringWithFormat:@"-%.0f",_firstValue];
    _roundD1.borderColor = @"f59c00";
    [coordinate addSubview:_roundD1];

    
    
    //底图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x+2, coordinate.frame.origin.y, coordinate.frame.size.width, coordinate.frame.size.height)];
    _backView.backgroundColor = [self colorFromHexString:@"a3d89f"];
    [self.view addSubview:_backView];
    _roundU3.adsorbView = _backView;

    
    //设定温度基准温度
    _upBaseView = [[UIView alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x+2, coordinate.frame.origin.y + coordinate.view_height_u, _roundU1.center.x, 30)];
    _upBaseView.backgroundColor = [self colorFromHexString:@"053076"];
    _upBaseView.alpha = 0.77;
    [self.view addSubview:_upBaseView];
    
    _downBaseView = [[UIView alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x+2, coordinate.frame.origin.y + coordinate.view_height_u + 50, _backView.frame.size.width, 30)];
    _downBaseView.backgroundColor = [self colorFromHexString:@"ffa303"];
    _downBaseView.alpha = 0.77;
    [self.view addSubview:_downBaseView];
    
    //可移动视图
    _roundViewU1 = [[UIView alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x + _roundU1.center.x, _roundU1.center.y + coordinate.frame.origin.y, _backView.frame.size.width - _roundU1.center.x + 2, coordinate.view_height_u - _roundU1.center.y + 30)];
    _roundViewU1.backgroundColor = [self colorFromHexString:@"053076"];
    _roundViewU1.alpha = 0.66;
    [self.view addSubview:_roundViewU1];
    
    _roundViewD1 = [[UIView alloc] initWithFrame:CGRectMake(_roundViewU1.frame.origin.x, coordinate.view_height_u + 50 + coordinate.frame.origin.y, _roundViewU1.frame.size.width, _roundViewU1.frame.size.height)];
    _roundViewD1.backgroundColor = [self colorFromHexString:@"ffa303"];
    _roundViewD1.alpha = 0.66;
    [self.view addSubview:_roundViewD1];

    _roundViewU2 = [[UIView alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x + _roundU2.center.x, _roundU2.center.y + coordinate.frame.origin.y, _backView.frame.size.width - _roundU2.center.x + 2, coordinate.view_height_u - _roundU2.center.y + 30)];
    _roundViewU2.backgroundColor = [self colorFromHexString:@"053076"];
    _roundViewU2.alpha = 0.58;
    [self.view addSubview:_roundViewU2];
    
    _roundViewD2 = [[UIView alloc] initWithFrame:CGRectMake(_roundViewU2.frame.origin.x, coordinate.view_height_u + 50 + coordinate.frame.origin.y, _roundViewU2.frame.size.width, _roundViewU2.frame.size.height)];
    _roundViewD2.backgroundColor = [self colorFromHexString:@"ffa303"];
    _roundViewD2.alpha = 0.58;
    [self.view addSubview:_roundViewD2];
    
    _roundViewU3 = [[UILabel alloc] initWithFrame:CGRectMake(coordinate.frame.origin.x + _roundU3.center.x, _upBaseView.frame.origin.y, _backView.frame.size.width - _roundU3.center.x + 2, _upBaseView.frame.size.height)];
    _roundViewU3.backgroundColor = [UIColor grayColor];
    _roundViewU3.text = @"关机";
    _roundViewU3.textAlignment = 1;
    _roundViewU3.textColor = [UIColor whiteColor];
    _roundViewU3.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_roundViewU3];
    
    _roundViewD3 = [[UILabel alloc] initWithFrame:CGRectMake(_roundViewU3.frame.origin.x, _downBaseView.frame.origin.y, _roundViewU3.frame.size.width, _roundViewU3.frame.size.height)];
    _roundViewD3.backgroundColor = [UIColor grayColor];
    _roundViewD3.text = @"关机";
    _roundViewD3.textAlignment = 1;
    _roundViewD3.textColor = [UIColor whiteColor];
    _roundViewD3.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_roundViewD3];
    
    //用户设定温度标题
    _upSetLabel = [[UILabel alloc] init];
    _upSetLabel.center = CGPointMake((_roundU3.center.x-_roundU1.center.x)/2 + _upBaseView.frame.size.width, coordinate.view_height_u + 10);
    _upSetLabel.bounds = CGRectMake(0, 0, _roundU3.center.x-_roundU1.center.x, _upBaseView.frame.size.height);
    _upSetLabel.textColor = [UIColor whiteColor];
    _upSetLabel.font = [UIFont systemFontOfSize:12];
    _upSetLabel.textAlignment = 1;
    _upSetLabel.text = @"用户制冷设定温度";
    [coordinate addSubview:_upSetLabel];

    _downSetLabel = [[UILabel alloc] init];
    _downSetLabel.center = CGPointMake(_upSetLabel.center.x, coordinate.view_height_u + 70);
    _downSetLabel.bounds = CGRectMake(0, 0, _roundU3.center.x-_roundU1.center.x, _upBaseView.frame.size.height);
    _downSetLabel.textColor = [UIColor whiteColor];
    _downSetLabel.font = [UIFont systemFontOfSize:12];
    _downSetLabel.textAlignment = 1;
    _downSetLabel.text = @"用户制热设定温度";
    [coordinate addSubview:_downSetLabel];
    
    [self sortView];
    [self updateBorderValue];
    [self updateViewFrame];
    [self updateVaule];

}
//视图排序
- (void)sortView {
    
    //视图排序
    [self.view sendSubviewToBack:_roundViewU3];
    [self.view sendSubviewToBack:_roundViewU2];
    [self.view sendSubviewToBack:_roundViewU1];
    [self.view sendSubviewToBack:_roundViewD3];
    [self.view sendSubviewToBack:_roundViewD2];
    [self.view sendSubviewToBack:_roundViewD1];
    [self.view sendSubviewToBack:_upBaseView];
    [self.view sendSubviewToBack:_downBaseView];
    [self.view sendSubviewToBack:_backView];
    [self.view bringSubviewToFront:coordinate];

}
//设置边界值 leftBorder - rightBorder
- (void)updateBorderValue {
    _roundU1.border_left = ROUNDSIZE/2;
    _roundU1.border_right = _roundU2.center.x-2;
    _roundU2.border_left = _roundU1.center.x + 2;
    _roundU2.border_right = _roundU3.center.x -2;
    _roundU3.border_right = coordinate.frame.size.width-ROUNDSIZE/2;
    _roundU3.border_left = _roundU2.center.x + 2;
    _roundU3.border_top = _roundU3.center.y;
    _roundU3.border_bottom = _roundU3.center.y;
    _roundU2.border_bottom = _roundU1.center.y;
    _roundU1.border_top = MAX(coordinate.view_height_u - coordinate.width_y*2, _roundU2.center.y) ;
}

//更新树叶和能耗标题的位置
- (void)updataLeafAndTitleFrame {
    [self updataLeafAndTitleFrameWithRound:_roundU1 ParentView:_roundViewU1 PicArr:_picObjArrU1 Up_Down:1];
    [self updataLeafAndTitleFrameWithRound:_roundU2 ParentView:_roundViewU2 PicArr:_picObjArrU2 Up_Down:1];
    [self updataLeafAndTitleFrameWithRound:_roundD1 ParentView:_roundViewD1 PicArr:_picObjArrD1 Up_Down:0];
    [self updataLeafAndTitleFrameWithRound:_roundD2 ParentView:_roundViewD2 PicArr:_picObjArrD2 Up_Down:0];
}

- (void)updataLeafAndTitleFrameWithRound:(RoundPanImageView*)roundView ParentView:(UIView*)parentView PicArr:(NSMutableArray*)picArr Up_Down:(BOOL)up{
    
    for (int i = 0; i<picArr.count; i++) {
        UIImageView * imageView = picArr[i];
        imageView.hidden = YES;
    }
    
    float width = (parentView.frame.size.height - 30)/(roundView.y_value * 2);
    int count = MIN(roundView.y_value, picArr.count);
    for (int i = 0; i<count; i++) {
        float Y = (2*i+1)*width;
        if (up == 0) {
            Y = (2*i+1)*width + 30;
        }

        UIImageView * imageView = picArr[i];
        imageView.hidden = NO;
        imageView.center = CGPointMake(parentView.frame.size.width/2, Y);
    }
    
    
    
}

#pragma mark  更新视图位置
- (void)updateViewFrame {
    _upBaseView.frame = CGRectMake(_backView.frame.origin.x, _upBaseView.frame.origin.y, _roundU1.center.x - 2, _upBaseView.frame.size.height);
    _downBaseView.frame = CGRectMake(_upBaseView.frame.origin.x, _downBaseView.frame.origin.y, _upBaseView.frame.size.width, _upBaseView.frame.size.height);
    _roundViewU1.frame = CGRectMake(coordinate.frame.origin.x + _roundU1.center.x, coordinate.frame.origin.y + _roundU1.center.y, _roundU2.center.x - _roundU1.center.x, coordinate.view_height_u - _roundU1.center.y + 30);
    _roundViewD1.frame = CGRectMake(_roundViewU1.frame.origin.x, coordinate.view_height_u + 50 + coordinate.frame.origin.y, _roundViewU1.frame.size.width, _roundViewU1.frame.size.height);
    _roundViewU2.frame = CGRectMake(coordinate.frame.origin.x + _roundU2.center.x, _roundU2.center.y + coordinate.frame.origin.y, _roundU3.center.x - _roundU2.center.x, coordinate.view_height_u - _roundU2.center.y + 30);
    _roundViewD2.frame = CGRectMake(_roundViewU2.frame.origin.x, _roundViewD1.frame.origin.y, _roundViewU2.frame.size.width, _roundViewU2.frame.size.height);
    _roundViewU3.frame = CGRectMake(coordinate.frame.origin.x + _roundU3.center.x, _roundViewU3.frame.origin.y , coordinate.frame.size.width - _roundU3.center.x, _roundViewU3.frame.size.height);
    _roundViewD3.frame = CGRectMake(_roundViewU3.frame.origin.x, _roundViewD3.frame.origin.y, _roundViewU3.frame.size.width, _roundViewU3.frame.size.height);
    _roundU3.center = CGPointMake(_roundU3.center.x, _roundU2.center.y);
    _roundD1.center = CGPointMake(_roundU1.center.x, coordinate.view_top_d + coordinate.width_y * _roundU1.y_value);
    _roundD2.center = CGPointMake(_roundU2.center.x, coordinate.view_top_d + coordinate.width_y * _roundU2.y_value);
    _roundD3.center = CGPointMake(_roundU3.center.x, _roundD2.center.y);
    _upSetLabel.center = CGPointMake((_roundU3.center.x-_roundU1.center.x)/2 + _upBaseView.frame.size.width, coordinate.view_height_u + 10);
    _downSetLabel.center = CGPointMake(_upSetLabel.center.x, coordinate.view_height_u + 70);
}

#pragma mark  更新数值
- (void)updateVaule {
    _roundD1.value = [NSString stringWithFormat:@"-%.0f℃",_roundU1.y_value];
    _roundD1.y_value = _roundU1.y_value;
    _roundD2.value = [NSString stringWithFormat:@"-%.0f℃",_roundU2.y_value];
    _roundD2.y_value = _roundU2.y_value;

}
#pragma mark  拖拽后更新坐标
- (void)updateAllViewFrameWithView:(RoundPanImageView*)panView {
    [self updateViewFrame];
    [self updateVaule];
    [self updateBorderValue];

}


#pragma mark
#pragma mark  拖拽协议
#pragma mark
- (void)endDragWithTag:(UIView *)view {
    NSLog(@"代理%ld",(long)view.tag);
    RoundPanImageView * panView = (RoundPanImageView*)view;
    if (panView.tag != 103) {
        float value = (coordinate.view_height_u-panView.center.y)/coordinate.width_y;
        panView.y_value = value;
        panView.value = [NSString stringWithFormat:@"+%.0f℃",value];
    }
    [self updateAllViewFrameWithView:panView];
    [self updataLeafAndTitleFrame];

}
- (void)dragWithTag:(UIView *)view {
    RoundPanImageView * panView = (RoundPanImageView*)view;
    if (panView.tag != 103) {
        float value = (coordinate.view_height_u-panView.center.y)/coordinate.width_y;
        panView.y_value = value;
        panView.value = [NSString stringWithFormat:@"+%.0f℃",value];
    }
    [self updateAllViewFrameWithView:panView];
    [self updataLeafAndTitleFrame];
}




//颜色
- (UIColor*)colorFromHexString:(NSString *)hexString{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
