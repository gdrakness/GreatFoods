//
//  IndexFirstCell.m
//  美食类
//
//  Created by 夏浩文 on 16/4/22.
//  Copyright © 2016年 夏浩文. All rights reserved.
//

#import "IndexFirstCell.h"


@interface IndexFirstCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imageFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imageSecond;

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UILabel *collect;
@property (weak, nonatomic) IBOutlet UILabel *zan;

@end


@implementation IndexFirstCell

- (void)awakeFromNib {
    //
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
