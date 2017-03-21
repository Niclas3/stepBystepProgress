//
//  ViewController.m
//  xxx
//
//  Created by niclas on 15/03/2017.
//  Copyright © 2017 niclas. All rights reserved.
//

#import "ViewController.h"
#import "SP_V_TrainProgress.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()
{
    float _re;
    
    float ress;
    NSArray *_actions;
}
@property (nonatomic, strong)  SP_V_TrainProgress *progressView;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 300, SCREEN_WIDTH, 5);
    _actions = [self genArrayStart:10 toEnd:20 Count:5];
    _progressView = [[SP_V_TrainProgress alloc] initWithFrame:rect andActionNumber:_actions];
    _progressView.backgroundColor = RGBCOLOR(48, 47, 50);
    _progressView.foregroundColor = [UIColor orangeColor];
    _progressView.progressValue = 0;
    [self.view addSubview:_progressView];
}

- (IBAction)changeDivider:(id)sender
{
    ress = 2;
    if (ress >= 0 && ress <= [_actions count] ) {
        [_progressView setAnimation:NO];
        [_progressView setProgressValue:ress];
        
    } else {
        return;
    }
    return;
}

- (IBAction)left:(id)sender {
    ress -= 1;
    if (ress >= 0) {
        [_progressView setAnimation:NO];
        [_progressView setProgressValue:ress];
    } else {
        ress = 0;
    }
}

- (IBAction)play:(id)sender {
    _progressView.animation = YES;
    ress = [_actions count];
    [_progressView setProgressValue:[_actions count]];
    [_progressView setSpeed:0.5];
}

- (IBAction)pause:(id)sender
{
    [_progressView setAnimation:NO];
    [_progressView stopProgress];
}


- (NSArray *)genArrayStart:(int)start toEnd:(int)end Count:(int)count
{
    NSMutableArray *array = [NSMutableArray array];
    while (count--) {
        int res = arc4random() % (end-start) + start;
        [array addObject:@(res)];
    }
    NSLog(@"%@", array);
    return [array copy];
}



@end
