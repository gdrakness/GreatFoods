//
//  BreakFastViewController.m
//  美食类
//
//  Created by 夏浩文 on 16/4/21.
//  Copyright © 2016年 夏浩文. All rights reserved.
//

#import "BreakFastViewController.h"
#import "IndexFirstCell.h"


#import <AFNetworking.h>
@interface BreakFastViewController () <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation BreakFastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //异步
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self GetData];
    });
    
    /* 创建UI*/
    [self buildUI];
    
}








#pragma mark- 创建UI

- (void) buildUI
{
    // your code
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 200;    //估高
    
    
    
}











#pragma mark- tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"breakFirst";
    static NSString *cellidTwo = @"breakSecond";
    static NSString *cellidThree = @"breakThird";
    
    
    //第一种cell (三个)
    if (indexPath.row % 6 == 1 ) {
        
        IndexFirstCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"IndexFirstCell" owner:self options:nil] lastObject];
        if (!cell) {
            cell = [[IndexFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        
        
        return cell;
    }
    
    
    //第二种cell (一个大)
    if (indexPath.row % 2 == 0 && indexPath.row % 3 == 0 && indexPath.row % 4 == 0 && indexPath.row % 6 == 0) {
        
    }
    
    
    //第三种cell (五个)
    if (indexPath.row % 5 == 0) {
        
    }
    
    
    return nil;
}







#pragma mark- tableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}











#pragma mark- 异步获取数据

- (void)GetData{
    
    self.DataSource = [NSMutableArray array];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        
        
        
        
        //主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    } failure:nil];
    
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
