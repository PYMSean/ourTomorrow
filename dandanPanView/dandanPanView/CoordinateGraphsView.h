//
//  CoordinateGraphsView.h
//  dandanPanView
//
//  Created by 庞工 on 2017/9/19.
//  Copyright © 2017年 YMDream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoordinateGraphsView : UIView

//高度都是基于该视图计算的
@property (nonatomic,assign)float unit_x;//单位间隔
@property (nonatomic,assign)float width_x;//x单位宽度
@property (nonatomic,assign)float unit_y;
@property (nonatomic,assign)float width_y;//y单位宽度
@property (nonatomic,assign)float view_height_u;//上边高度
@property (nonatomic,assign)float view_height_d;//下面位置
@property (nonatomic,assign)float view_bottom_u;//上边视图底部位置
@property (nonatomic,assign)float view_top_d;//下边视图顶部位置
@property (nonatomic,copy)NSString * backgroundColor;

- (id)initWithFrame:(CGRect)frame;

@end
