//
//  PhotoTableViewController.m
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "PhotoCell.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "GCD.h"


static NSString *URL = @"https://www.apiopen.top/meituApi";

@interface PhotoTableViewController ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray<PhotoCellData *> *data;

@property (nonatomic, assign) BOOL                             isFetching;

@property (nonatomic, assign) NSInteger                        page;

@property (nonatomic, strong) GCDSemaphore                    *semaphore;

@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor                     = [UIColor whiteColor];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight                    = Height / 2.7;
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.alpha              = 0.5f;
    
    self.page      = 2;
    self.semaphore = [[GCDSemaphore alloc] init];

    [self.tableView registerClass:[PhotoCell class] forCellReuseIdentifier:@"PhotoCell"];
    
    [self loadPhotoDataUsePage:1];
    
    MJRefreshNormalHeader *header     = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPhotoDataUsePage:1];
    }];
    self.tableView.mj_header          = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadPhotoDataUsePage:self.page];
    }];
    self.tableView.mj_footer          = footer;

    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PhotoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.data = self.data[indexPath.row];
    [cell cellOffset];
    [cell loadContent];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(PhotoCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [cell cancelAnimation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray <PhotoCell *> *array = [self.tableView visibleCells];
    
    [array enumerateObjectsUsingBlock:^(PhotoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj cellOffset];
    }];
    
    if (_isFetching) return;
    
    CGPoint      offset          = scrollView.contentOffset;
    CGFloat      contentHeight   = scrollView.contentSize.height;
    CGFloat      height          = scrollView.bounds.size.height;
    UIEdgeInsets inset           = scrollView.contentInset;
    
    CGFloat      offsetY         = offset.y - inset.bottom - inset.top; //偏移量
    CGFloat      threshold       = contentHeight - height * 2; // 阈值
    
    if (offsetY >= threshold) {
        [self loadPhotoDataUsePage:self.page];
    }
}

- (void)loadPhotoDataUsePage:(NSInteger)page {
    
    if (page == 1) self.data = @[].mutableCopy;
    
    
    _isFetching = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer    = [AFJSONResponseSerializer serializer];
    manager.securityPolicy        = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    NSMutableDictionary *params   = @{}.mutableCopy;
    [params setValue:@(page) forKey:@"page"];
    
    [manager GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([self.tableView.mj_header isRefreshing]) [self.tableView.mj_header endRefreshing];
        if ([self.tableView.mj_footer isRefreshing]) [self.tableView.mj_footer endRefreshing];
        
        PhotoCellEntiry *entity = [[PhotoCellEntiry alloc] initWithDictionary:responseObject];
        [self.data addObjectsFromArray:entity.data];
        
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
            
        }];
        
        if (self.page == 2) {
            [UIView animateWithDuration:0.35f animations:^{
                self.tableView.alpha = 1.f;
            }];
        }
        [self.semaphore signal];
        self.isFetching = NO;
        if (self.page >= 2) self.page++;
        [self.semaphore wait];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.tableView.mj_header isRefreshing]) [self.tableView.mj_header endRefreshing];
        if ([self.tableView.mj_footer isRefreshing]) [self.tableView.mj_footer endRefreshing];
        self.isFetching = NO;
        NSLog(@"%@", error);
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
