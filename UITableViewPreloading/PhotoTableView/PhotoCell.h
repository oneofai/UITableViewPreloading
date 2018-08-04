//
//  PhotoCell.h
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCellData.h"
#import "UIView+SetRect.h"

@interface PhotoCell : UITableViewCell

@property (nonatomic, strong) PhotoCellData *data;

@property (nonatomic, weak)   UITableView *tableView;

@property (nonatomic, weak)   NSIndexPath *indexPath;

- (CGFloat)cellOffset;

- (void)cancelAnimation;

- (void)loadContent;

//+ (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
