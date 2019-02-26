//
//  RoundPanImageView.h
//  dandanPanView
//
//  Created by 庞工 on 2017/9/18.
//  Copyright © 2017年 YMDream. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundPanViewDelegate <NSObject>

@required
- (void)endDragWithTag:(UIView*)view;
- (void)dragWithTag:(UIView*)view;

@end


@interface RoundPanImageView : UIImageView
@property (nonatomic,copy)NSString * value;//当前值
@property (nonatomic,assign)float x_value;//当前值
@property (nonatomic,assign)float y_value;//当前值
@property (nonatomic,strong)UILabel * valueLabel;
@property (nonatomic,assign)float border_left;//左边界
@property (nonatomic,assign)float border_right;//右边界
@property (nonatomic,assign)float border_top;//上边界
@property (nonatomic,assign)float border_bottom;//下边界
@property (nonatomic,strong)UIPanGestureRecognizer * pan;//拖动手势
@property (nonatomic,copy)NSString * imagename;//背景图
@property (nonatomic,strong)UIView * desView;//目标视图
@property (nonatomic,strong)UIView * adsorbView;//吸附视图
@property (nonatomic,assign)float step_x;//x轴单位长度
@property (nonatomic,assign)float step_y;
@property (nonatomic,assign)float lastPointX;
@property (nonatomic,assign)float lastPointY;
@property (nonatomic,copy)NSString * borderColor;
@property (nonatomic,copy)NSString * valueColor;
@property (nonatomic,assign)id<RoundPanViewDelegate>delegate;
@property (nonatomic,assign)BOOL enable;//是否允许滑动


/*
 *  初始化panRoundView
 */
- (id)initPanRoundViewWithCenter:(CGPoint)center Size:(CGSize)size DesView:(UIView*)desView;

@end
