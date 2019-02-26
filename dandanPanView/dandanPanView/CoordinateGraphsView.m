//
//  CoordinateGraphsView.m
//  dandanPanView
//
//  Created by 庞工 on 2017/9/19.
//  Copyright © 2017年 YMDream. All rights reserved.
//

#import "CoordinateGraphsView.h"
#define H1 30
#define H2 20
#define H3 30
@implementation CoordinateGraphsView

- (id)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.frame = frame;
        [self viewLayout];
    }
    
    return self;
}

- (void)viewLayout {
    UIView * leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.frame.size.height)];
    leftLine.backgroundColor = [self colorFromHexString:@"2e8a7d"];
    [self addSubview:leftLine];
    
    float middle = (self.frame.size.height - H2 - H1 - H3)/2;
    self.view_height_u = middle;
    self.view_height_d = middle;
    self.view_bottom_u = middle;
    self.view_top_d = middle+H1+H2+H3;
    self.width_x = (self.frame.size.width - 20)/12;
    self.width_y = (middle-20)/5;
    
    UIView * upLine = [[UIView alloc] initWithFrame:CGRectMake(2, middle + H1, self.frame.size.width-2, 1)];
    upLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:upLine];
    [self drawCoordinationXWithView:upLine direction:1];
    
    UIView * downLine = [[UIView alloc] initWithFrame:CGRectMake(2, middle + H1 + H2, self.frame.size.width-2, 1)];
    downLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:downLine];
    [self drawCoordinationXWithView:downLine direction:0];
    [self drawCoordinationYWithDirection:0];
    [self drawCoordinationYWithDirection:1];
    [self drawDataViewWithView:downLine];

    

    
}

- (void)drawCoordinationXWithView:(UIView*)view direction:(int)direction {
    float width = (view.frame.size.width - 20)/12;
    int Y = 0;
    if (direction == 0) {
        Y = view.frame.origin.y+1;
    }else{
        Y = view.frame.origin.y-3;
    }
    for (int i = 0; i<12; i++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake((i+1)*width, Y, 1, 3)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
    }
}
- (void)drawCoordinationYWithDirection:(int)direction {
    float height = (self.view_height_u-20)/5;
    int Y = 0;
    if (direction == 0) {
        Y = self.view_top_d;
        for (int i = 0; i<5; i++) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(2, Y+(i+1)*height, 3, 1)];
            line.backgroundColor = [self colorFromHexString:@"2e8a7d"];
            [self addSubview:line];
        }
    }else{
        Y = self.view_height_u;
        for (int i = 0; i<5; i++) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(2, Y-(i+1)*height, 3, 1)];
            line.backgroundColor = [self colorFromHexString:@"2e8a7d"];
            [self addSubview:line];
        }
    }
}

- (void)drawDataViewWithView:(UIView*)view {
    float width = (view.frame.size.width - 20)/4;
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(2, self.view_bottom_u+H1+1, view.frame.size.width, H2-1)];
    view1.backgroundColor = [self colorFromHexString:@"2e8a7d"];
    [self addSubview:view1];

    NSArray * arr = @[@"0",@"30",@"60",@"90",@"120min"];
    for (int i = 0; i<5; i++) {
        float X = i*width+2;
        if (i>0) {
            X = i*width-6;
        }
        if (i==4) {
            X = i*width-20;
        }
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(X, self.view_bottom_u+H1, width, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = arr[i];
        [self addSubview:label];
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
