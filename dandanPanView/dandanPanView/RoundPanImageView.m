//
//  RoundPanImageView.m
//  dandanPanView
//
//  Created by 庞工 on 2017/9/18.
//  Copyright © 2017年 YMDream. All rights reserved.
//

#import "RoundPanImageView.h"

@implementation RoundPanImageView

- (id)initPanRoundViewWithCenter:(CGPoint)center Size:(CGSize)size DesView:(UIView*)desView {
    CGRect frame = CGRectMake(center.x - size.width/2, center.y - size.height/2, size.width, size.height);
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.desView = desView;
        self.lastPointX = center.x;
        self.lastPointY = center.y;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = size.width/2;
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        [self ViewLayout];
    }
    
    return self;
}

- (void)ViewLayout {
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.bounds = CGRectMake(0, 0, self.frame.size.width-4, self.frame.size.height-4);
    self.valueLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.valueLabel.clipsToBounds = YES;
    self.valueLabel.font = [UIFont systemFontOfSize:12];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.textAlignment = 1;
    self.valueLabel.layer.cornerRadius = self.valueLabel.frame.size.width/2;
    self.valueLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.valueLabel];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWay:)];
    [self addGestureRecognizer:self.pan];
    
}

#pragma mark
#pragma mark  set way
- (void)setValue:(NSString *)value {
    _value = value;
    self.valueLabel.text = value;
}
- (void)setBorderColor:(NSString *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = [self colorFromHexString:borderColor].CGColor;
    self.valueLabel.backgroundColor = [self colorFromHexString:borderColor];
}
- (void)setValueColor:(NSString *)valueColor {
    
}
- (void)setImagename:(NSString *)imagename {
    _imagename = imagename;
    self.image = [UIImage imageNamed:_imagename];
}
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.pan.enabled = enable;
}

#pragma mark
- (void)panWay:(UIPanGestureRecognizer*)pan {
    NSLog(@"拖动啦");
    CGPoint originationPoint = pan.view.center;
    CGPoint incrementPoint = [pan translationInView:self.desView];
    
    float des_x = originationPoint.x + incrementPoint.x;
    float des_y = originationPoint.y + incrementPoint.y;
    
    if ((originationPoint.x >= self.border_left) && (originationPoint.x <= self.border_right) && (originationPoint.y >= self.border_top) && (originationPoint.y <= self.border_bottom)) {
        self.center = CGPointMake(des_x, des_y);
        
        //四个角落
        //left-bottom
        if ((self.center.x < self.border_left) && (self.center.y > self.border_bottom)) {
            self.center = CGPointMake(self.border_left, self.border_bottom);
        }else if ((self.center.x > self.border_right) && (self.center.y > self.border_bottom)) {
            //right-bottom
            self.center = CGPointMake(self.border_right, self.border_bottom);
        }else if ((self.center.x < self.border_left) && (self.center.y < self.border_top)) {
            //left-top
            self.center = CGPointMake(self.border_left, self.border_top);
        }else if ((self.center.x > self.border_right) && (self.center.y < self.border_top)) {
            //right-top
            self.center = CGPointMake(self.border_right, self.border_top);
        }else{
            //other
            //修正 y-轴
            if (self.center.x < self.border_left) {
                self.center = CGPointMake(self.border_left, des_y);
            }else if (self.center.x > self.border_right){
                self.center = CGPointMake(self.border_right, des_y);
            }
            
            //x-轴
            if (self.center.y < self.border_top) {
                self.center = CGPointMake(des_x, self.border_top);
            }else if (self.center.y > self.border_bottom){
                self.center = CGPointMake(des_x, self.border_bottom);
            }

        }
        
        [self.pan setTranslation:CGPointZero inView:self.desView];
        
        [self.delegate dragWithTag:self];

        if (pan.state == UIGestureRecognizerStateEnded) {
            NSLog(@"滑动结束!");
            NSLog(@"起始位置：x_%f,y_%f",self.lastPointX,self.lastPointY);

            float incrementx = self.lastPointX-self.center.x;
            float incrementy = self.lastPointY-self.center.y;
            float result_x = fabsf(incrementx);
            float result_y = fabsf(incrementy);
            int step_x = result_x/self.step_x;
            int step_y = result_y/self.step_y;
            if (incrementx>0) {
                //x值减小
                self.center = CGPointMake(_lastPointX - self.step_x*step_x, self.center.y);
            }else{
                //x值增大
                self.center = CGPointMake(_lastPointX + self.step_x*step_x, self.center.y);
            }
            
            if (incrementy>0) {
                //y值减小
                self.center = CGPointMake(self.center.x, _lastPointY - self.step_y*step_y);
            }else{
                //y值增大
                self.center = CGPointMake(self.center.x, _lastPointY + self.step_y*step_y);
            }
            
            //改变缓存的值
            self.lastPointX = self.center.x;
            self.lastPointY = self.center.y;
            
            NSLog(@"目标位置：x_%f,y_%f",self.center.x,self.center.y);
            
            [self.delegate endDragWithTag:self];
            
        }

    }
    
    
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

@end
