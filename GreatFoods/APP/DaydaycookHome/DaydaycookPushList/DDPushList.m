//
//  DDPushList.m
//  美食类
//
//  Created by 夏浩文 on 16/4/19.
//  Copyright © 2016年 夏浩文. All rights reserved.
//

#import "DDPushList.h"
#import "SearchViewController.h"

@implementation DDPushList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{

}

- (IBAction)Time:(UIButton *)sender {
    
}
- (IBAction)breakfast:(UIButton *)sender {
    
}
- (IBAction)search:(UIButton *)sender {
    SearchViewController *search = [SearchViewController new];
    [[self viewController].navigationController pushViewController:search animated:YES];
}
- (IBAction)mine:(UIButton *)sender {
    
}


- (UIViewController*)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
