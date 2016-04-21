//
//  TimerViewController.m
//  美食类
//
//  Created by 夏浩文 on 16/4/21.
//  Copyright © 2016年 夏浩文. All rights reserved.
//

#import "TimerViewController.h"
#import "BigRoundView.h"
#import "SmRoundView.h"
#import "PointView.h"
@interface TimerViewController ()
@property (weak, nonatomic) IBOutlet SmRoundView *smRoundView;
@property (weak, nonatomic) IBOutlet BigRoundView *bigRoundView;
@property (weak, nonatomic) IBOutlet PointView *pointView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIView *timeoutView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property(nonatomic,strong)dispatch_source_t time;
@property(nonatomic,strong)dispatch_source_t time1;
@property(nonatomic,assign)NSInteger timeout;
@property(nonatomic,assign)CGFloat progressCount;

@property(nonatomic,retain)UIColor *color;
@end

@implementation TimerViewController

//开始计时
- (IBAction)startAction:(id)sender {
    if ([self.countLabel.text integerValue] ==0) {
        
    }else{
        
        [self action];
        
        [self.countLabel.superview setHidden:YES];
    }
}
//暂停按钮
- (IBAction)stopAction:(id)sender {
    UIButton *btn = sender;
    if (btn.selected == 0) {
        [self stopTimer];
    }
    else{
        
        [self startTimer];
        
    }
    btn.selected = !btn.selected;
    
    
}

//暂停倒计时
-(void)stopTimer{
    
    dispatch_source_cancel(self.time1);
    self.time1 = nil;
    dispatch_source_cancel(self.time);
    self.time = nil;
    
    
}
//取消按钮
- (IBAction)cancelAction:(id)sender {
    if (self.time) {
        [self stopTimer];
    }
        [self cancelTimer];

   
}
//取消倒计时
-(void)cancelTimer{
    self.color = [UIColor whiteColor];
    self.bigRoundView.changeColor =  self.color;
    [self.bigRoundView setNeedsDisplay];
    self.smRoundView.changeColor =  self.color;
    self.pointView.changeColor =  self.color;
    [self.pointView setNeedsDisplay];

    [self.startBtn setHidden:NO];
    [self.timeoutView setHidden:YES];
    [self.bigRoundView setHidden:YES];
    [self.startBtn setHidden:NO];
    self.countLabel.text = @"0";
    [self.countLabel.superview setHidden:NO];
    self.smRoundView.minProgress = 0.0;
    self.progressCount = 0,0;
    self.smRoundView.progress = 0.0;
    
}
-(void)startTimer{
    
    __weak TimerViewController *weakSelf = self;
    
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self timerAction];
        
    });
    self.time = timer;
    dispatch_resume(timer);
    
    
    dispatch_source_t timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer1, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer1, ^{
        
        if (  weakSelf.timeout <= 0 ) {
            [self cancelTimer];
            
        }else{
            NSInteger minutes =   weakSelf.timeout / 60;
            NSInteger seconds =   weakSelf.timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                weakSelf.smRoundView.minProgress = minutes / 60.0;
                weakSelf.minutesLabel.text = [NSString stringWithFormat:@"%ld",minutes];
                
                if (seconds % 5 == 0) {
                    UIColor *color = [UIColor colorWithRed:(arc4random()%255)/255. green:(arc4random()%255)/255. blue:(arc4random()%255)/255. alpha:1];
                    weakSelf.color = color;
                    weakSelf.bigRoundView.changeColor =  weakSelf.color;
                    [weakSelf.bigRoundView setNeedsDisplay];
                    weakSelf.smRoundView.changeColor =  weakSelf.color;
                    weakSelf.pointView.changeColor =  weakSelf.color;
                    [weakSelf.pointView setNeedsDisplay];
                    weakSelf.minutesLabel.textColor = weakSelf.color;
                    weakSelf.secondsLabel.textColor = weakSelf.color;
                    [weakSelf.stopBtn setTitleColor:weakSelf.color forState:UIControlStateNormal];
                    
                    [weakSelf.cancelBtn setTitleColor:weakSelf.color forState:UIControlStateNormal];
                    
                }
                if ([weakSelf.minutesLabel.text integerValue] < 10) {
                    weakSelf.minutesLabel.text = [NSString stringWithFormat:@"0%@",weakSelf.minutesLabel.text];
                }
                
                
                //怎么解决,一定要在后面再次调用get方法才行
                //                NSLog(@"%@",weakSelf.minutesLabel);
                
                weakSelf.secondsLabel.text = [NSString stringWithFormat:@"%ld",seconds];
                if ([weakSelf.secondsLabel.text integerValue] < 10) {
                    weakSelf.secondsLabel.text = [NSString stringWithFormat:@"0%@",weakSelf.secondsLabel.text];
                }
                
            });
            
        }
        
        
        
        weakSelf.timeout -- ;
        [self timerAction1];
    });
    self.time1 = timer1;
    dispatch_resume(timer1);
    
    
    
}
-(void)action{
    
    
    [self.startBtn setHidden:YES];
    [self.timeoutView setHidden:NO];
    [self.bigRoundView setHidden:NO];
    self.timeout = [self.countLabel.text integerValue] * 60;
    [self startTimer];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.stopBtn setTitle:@"继续" forState:UIControlStateSelected];
    self.smRoundView.minBlock = ^(NSInteger min){
        
        self.countLabel.text = [NSString stringWithFormat:@"%ld",min];
    };
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.countLabel.bounds.size.width, self.countLabel.bounds.size.height)];
    button.center = self.view.center;
//    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
}


-(void)btnAction{
    NSInteger min = [self.countLabel.text integerValue];
    min ++ ;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",min];
    if (min / 60 <= 1) {
        self.smRoundView.minProgress = min / 60.0;
    }
    
    
    
    
}

-(void)timerAction1{
    
    
    
    
}
-(void)timerAction{
    
    _smRoundView.progress = 1 - _progressCount / 60.0;
    if (_progressCount >= 60.0) {
        
        _progressCount = 0.0;
    }
    _progressCount = _progressCount + 0.1;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
