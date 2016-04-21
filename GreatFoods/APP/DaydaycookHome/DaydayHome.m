//
//  DaydayHome.m
//  美食类
//
//  Created by 夏浩文 on 16/4/18.
//  Copyright © 2016年 夏浩文. All rights reserved.
//

#import "DaydayHome.h"
#import "DDCollectCell.h"
#import "DDCLoopLayout.h"
#import "DDPushList.h"
#import "DaydayCookDescription.h"
#import "DDCLoopLayout.h"

#import <AFNetworking.h>
#import <UIScrollView+JElasticPullToRefresh.h>
@interface DaydayHome () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger isRefreshCount;//记录刷新次数
    DDPushList *PushListView;//导航菜单
}
@property (retain, nonatomic) UICollectionView *DaydayCollecionView;
@property (weak, nonatomic) IBOutlet UIButton *ListButton;//推出按钮

@end

@implementation DaydayHome

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    
    #pragma mark- 刷新条 JELasticRefresh
    
    JElasticPullToRefreshLoadingViewCircle *loadCircle = [JElasticPullToRefreshLoadingViewCircle new];
    loadCircle.tintColor = selectColor;//圈圈颜色
    
    __weak __typeof(self)weakSelf = self;
    [self.DaydayCollecionView addJElasticPullToRefreshViewWithActionHandler:^{
        //延迟1.5s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.DaydayCollecionView stopLoading];
        });
    } LoadingView:loadCircle];
    //fill颜色
    [self.DaydayCollecionView setJElasticPullToRefreshFillColor:BabyPinkColor];
    //背景颜色
    [self.DaydayCollecionView setJElasticPullToRefreshBackgroundColor:self.DaydayCollecionView.backgroundColor];
    
    /* 去除该死的bar发际线 (背景navbar合一)perfect */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    /**
     *  @author 夏浩文
     *
     *  菜单列表按钮
     *
     */
    
    self.title = @"DayDayCook";
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  @author 夏浩文
     *
     *  collectionview
     */
    self.DaydayCollecionView = [[UICollectionView alloc]
                                initWithFrame:self.view.frame collectionViewLayout:[DDCLoopLayout new]];
    self.DaydayCollecionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_DaydayCollecionView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self DayDayCookHomeDataIFRefresh:NO];
    
    self.DaydayCollecionView.delegate = self;
    self.DaydayCollecionView.dataSource = self;
    
    //注册cell
    [self.DaydayCollecionView registerNib:[UINib nibWithNibName:@"DDCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"daydayhome"];
    //?
    [self.DaydayCollecionView setDecelerationRate:UIScrollViewDecelerationRateFast];

    #pragma mark- 调用创建退出窗口方法
    [self buildPushListView];
}



#pragma mark- 记录可见cell数量(自动下拉刷新cell)
-(void)viewDidAppear:(BOOL)animated{
    isRefreshCount = self.DaydayCollecionView.visibleCells.count;
}








#pragma mark- UICollectionViewDataSource
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.DDdataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    #pragma mark- cell代理方法
    
    static NSString *cellid = @"daydayhome";
    DDCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    DaydayCookData *model = self.DDdataArray[indexPath.item];
    [cell getModel:model];
    return cell;
}








#pragma mark- UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DaydayCookDescription *VC = [DaydayCookDescription new];
    
    DaydayCookData *model = self.DDdataArray[indexPath.item];
    VC.BookID = model.dataIdentifier;
    
    [self.navigationController pushViewController:VC animated:YES];
}









#pragma mark- scrolldelegate

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    /*  */
//    NSLog(@"%f = %lu",scrollView.contentOffset.y / 180,self.DDdataArray.count - 5 );
    if (scrollView.contentOffset.y / 180  > self.DDdataArray.count - 10 ) {
        [self DayDayCookHomeDataIFRefresh:YES];
    }//减速判定是否刷新页面
}













#pragma mark- 菜单推出导航页面
- (void)buildPushListView{
    PushListView = [[[NSBundle mainBundle]loadNibNamed:@"DDPushList" owner:self options:nil] lastObject];
    [PushListView setFrame:CGRectMake(0, screen_height, screen_width, 170)];
    
    [self.view addSubview:PushListView];
    [self.view bringSubviewToFront:PushListView];
}











#pragma mark- 菜单列表按钮
- (IBAction)PushList:(UIButton *)sender
{
    //不允许点击
    self.DaydayCollecionView.userInteractionEnabled = NO;
    //navBar上移
    [UIView animateWithDuration:1 animations:^{
        
        sender.alpha = 0;
        [self.navigationController.navigationBar setAlpha:0];
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(self.navigationController.navigationBar.transform, 0, -64);//向上移动
    }];
    //pushView上移
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        PushListView.transform = CGAffineTransformTranslate(PushListView.transform, 0, -170);
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//状态栏白色
        self.DaydayCollecionView.transform = CGAffineTransformTranslate(PushListView.transform, 0, 0);
    } completion:^(BOOL finished) {
        NSLog(@"animate completly");
    }];
}
//导航回滚
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //pushView下移
    [UIView animateWithDuration:.5 animations:^{
        PushListView.transform = CGAffineTransformIdentity;
        self.DaydayCollecionView.transform = CGAffineTransformTranslate(PushListView.transform, 0, 0);
    } completion:^(BOOL finished) {
        //navBar下移
        [UIView animateWithDuration:.3 animations:^{
            self.ListButton.alpha = 1;
            [self.navigationController.navigationBar setAlpha:1];
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//状态栏
            //允许点击
            self.DaydayCollecionView.userInteractionEnabled = YES;
        }];
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    }];
    

    
}





#pragma mark- 刷新页面

-(void)DayDayCookHomeDataIFRefresh:(BOOL)isrefresh;
{
    if (isrefresh == YES) {
        RefreshCurrentPage++;//下拉刷新
    }
    NSString *url = [NSString stringWithFormat:@"http://218.244.151.213/daydaycook/server/recipe/index.do?currentPage=%ld&pageSize=20",RefreshCurrentPage];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"msg"] isEqualToString:@"成功"]) {
            
            NSArray *dataArray = responseObject[@"data"];
            for (NSDictionary *dic in dataArray) {
                DaydayCookData *model = [DaydayCookData modelObjectWithDictionary:dic];
                [self.DDdataArray addObject:model];
            }
            /* 刷新*/
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.DaydayCollecionView reloadData];
            });
        }
    } failure:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








#pragma mark- 添加渐变色











#pragma mark- 释放动画
-(void)dealloc
{
    [self.DaydayCollecionView removeJElasticPullToRefreshView];
    NSLog(@"释放~");
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