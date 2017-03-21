//
//  SP_V_TrainProgress.m
//  xxx
//
//  Created by niclas on 15/03/2017.
//  Copyright © 2017 niclas. All rights reserved.
//

#import "SP_V_TrainProgress.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define CELLWIDTH    2     // 间隔灰色小块本体单位宽度 px


@interface SP_V_TrainProgress()

@property (nonatomic, assign) int        endProgress;

@property (nonatomic, assign) CGFloat    prePosition;

@property (nonatomic, strong) CADisplayLink   *timer;

@property (nonatomic, strong) NSMutableArray *positionArray;


@end

@implementation SP_V_TrainProgress


// 这个初始化接口接受一个数组，填入动作需要的次数或者秒数用于划分小块
- (instancetype)initWithFrame:(CGRect)frame andActionNumber:(NSArray *)actions
{
    self = [super initWithFrame:frame];
    if (self) {
        _progressValue = 0;
        [self setBackgroundColor: RGBCOLOR(48, 47, 50)];
        _foregroundColor = RGBCOLOR(239, 85, 35);
        _dividetionColor = RGBCOLOR(81, 81, 82);
        _progressBgColor = RGBCOLOR(48, 47, 50);
        _positionArray   = [NSMutableArray arrayWithObjects:@(0), nil];
        _currentProgress = 0;
        _actionArray     = actions ;
    }
    return self;
}

-(int)currentProgress
{
    return 10;

}

//- (int)reduceCurrentPositionToNumberWithDirection:(ProgressDiretion)diretion
//{
//    if (diretion == PROGRESS_PRIV) {
//        
//    } else if (diretion == PROGRESS_NEXT){
//        
//    }
//}


#pragma mark - private methods
/*
 * 间隔之间空格的单位宽度
 */
- (CGFloat)cellSpacewidth
{
    return  (SCREEN_WIDTH - CELLWIDTH * ([_actionArray count] - 1 ) ) / [self sumOfActions:_actionArray];
}

- (CGFloat)sumOfActions:(NSArray *) array
{
    __block CGFloat resalut = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        resalut += [obj floatValue];
    }];
    return resalut;
}


- (void)setProgressValue:(int)progressValue
{
    if (progressValue < 0) _progressValue = 0;
    _endProgress = progressValue;
    if (self.animation == NO) {
        _endProgress = [self convertActionNumberWithPosition:_prePosition];
        _progressValue = _endProgress;
        [self setNeedsDisplay];
    } else {
        [self startAnimationProgress];
        return;
    }
}

- (int)convertActionNumberWithPosition:(CGFloat)position
{
    __block NSUInteger index = 0;
    [_positionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (position < [obj floatValue]) {
            index = idx;
            *stop = YES;
        }
    }];
    return (int)index;
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProgressBackground:context inRect:rect];
    
    if (self.progressValue > 0 || _endProgress > 0) {
        [self drawProgress:context withFrame: rect];
    }
}

- (void)drawDividerView:(CGContextRef)context
{
    if ([_actionArray count] > 0) {
        CGFloat pointNumber = [_actionArray count] - 1;
        CGFloat prePosition = 0;
        for (int i = 0 ; i < pointNumber; i++)
        {
            CGFloat position = prePosition + CELLWIDTH + [self cellSpacewidth] * [_actionArray[i] floatValue];
            
            if ([_positionArray count] < [_actionArray count] + 1) {
                [_positionArray addObject:@(position)];
            }
            prePosition = position;
            CGRect actrect = CGRectMake(position, 0, CELLWIDTH, self.frame.size.height);
        
            CGContextSaveGState(context);
            UIBezierPath *divider = [UIBezierPath bezierPathWithRect:actrect];
            CGContextSetFillColorWithColor(context, self.dividetionColor.CGColor);
            [divider fill];
        }
        
        if ([_positionArray count] < [_actionArray count] + 1) {
            [_positionArray addObject:@([UIScreen mainScreen].bounds.size.width)];
        }
    } else {
        
    }
}

- (void)drawProgressBackground:(CGContextRef)context inRect:(CGRect)rect
{
       [self drawDividerView:context];
}


- (void)drawProgress:(CGContextRef)context withFrame:(CGRect)frame {
    CGFloat width = 0;
    if (!_animation) {
        width = [self numberOfAction2Position:_progressValue] ;
        _prePosition = width;
    } else {
        width = _prePosition;
    }
    
    CGRect drawRect = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:drawRect
                                                          byRoundingCorners:UIRectCornerTopLeft |
                                                                            UIRectCornerBottomLeft
                                                                cornerRadii: CGSizeMake(drawRect.size.height/2, drawRect.size.height/2)];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    [roundedRect fill];
}


- (void)startAnimationProgress
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_prePosition == 0) {
        _prePosition = [self numberOfAction2Position:_progressValue];
    } else {
    
    }
    self.timer =[CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)updateProgress
{
    if (fabs(_prePosition - [self numberOfAction2Position:_endProgress]) < _speed ||
        _prePosition >= [_positionArray[[_positionArray count] -1] floatValue]){
        _progressValue = _endProgress;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        _prePosition += _speed;
        [self setNeedsDisplay];
    }
}

- (void)stopProgress
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (CGFloat)numberOfAction2Position: (int)num
{   // array 不存在为0；
    CGFloat width = 0;
    if (_endProgress < [_positionArray count] && _progressValue >= 0) {
        width = [_positionArray[num] floatValue]; // 对应步骤的值
    } else {
        width = [_positionArray[[_positionArray count] -1] floatValue]; // 最后一个值
    }
    return width;
}

@end
