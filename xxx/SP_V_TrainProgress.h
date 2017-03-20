//
//  SP_V_TrainProgress.h
//  xxx
//
//  Created by niclas on 15/03/2017.
//  Copyright © 2017 niclas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SP_V_TrainProgress : UIView
/*
 *  绘制间隔 UIProgress 
 */

//进度条 第几节课
@property (nonatomic, assign) int           progressValue;

@property (nonatomic, strong) UIColor       *progressBgColor;
//进度颜色
@property (nonatomic, strong) UIColor       *foregroundColor;

//间隔颜色
@property (nonatomic, strong) UIColor       *dividetionColor;

//默认YES
@property (nonatomic, assign) BOOL          animation;

@property (nonatomic, strong) NSArray       *actionArray;

// 
- (instancetype)initWithFrame:(CGRect)frame andActionNumber:(NSArray *)actions;
/**
 设置进度条的宽度
 
 @param width 宽度
 */
- (void)setProgressWidth:(float)width;

@end
