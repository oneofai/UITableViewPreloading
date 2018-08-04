//
//  ViewController.m
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSDictionary *> *itemArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView            = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PreloadingCell"];
    [self.view addSubview:self.tableView];
    
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className  = self.itemArray[indexPath.row][@"controller"];
    Class cls            = NSClassFromString(className);
    UIViewController *vc = [[cls alloc] init];
    vc.title             = self.itemArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"PreloadingCell"];
    cell.textLabel.text       = [NSString stringWithFormat:@"%ld.%@", (long)indexPath.row + 1, self.itemArray[indexPath.row][@"title"]];
    cell.detailTextLabel.text = self.itemArray[indexPath.row][@"controller"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (NSArray<NSDictionary *> *)itemArray {
    return @[@{@"controller" : @"CombineTableViewController",
               @"title"      : @"图文"},
            @{ @"controller" : @"PhotoTableViewController",
               @"title"      : @"照片"}];
}

@end
