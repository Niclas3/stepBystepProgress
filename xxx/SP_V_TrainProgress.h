//
//  SP_V_TrainProgress.h
//  xxx
//
//  Created by niclas on 15/03/2017.
//  Copyright © 2017 niclas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PROGRESS_PRIV,
    PROGRESS_NEXT,
} ProgressDiretion;

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

//速度
@property (nonatomic, assign) CGFloat       speed;

//现在的进度
@property (nonatomic, assign) int   currentProgress;


- (instancetype)initWithFrame:(CGRect)frame andActionNumber:(NSArray *)actions;

- (void)stopProgress;

@end
