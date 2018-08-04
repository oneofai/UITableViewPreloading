//
//  PhotoCellData.h
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PhotoCellData : NSObject

/** 创建时间 */
@property (nonatomic, copy) NSString *createdAt;

/** 发布时间 */
@property (nonatomic, copy) NSString *publishedAt;

/** 裁剪过的日期 */
@property (nonatomic, copy) NSString *dateString;

/** 图片类型 */
@property (nonatomic, copy) NSString *type;

/** URL */
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface PhotoCellEntiry : NSObject

@property (nonatomic, strong) NSNumber      *code;

@property (nonatomic,   copy) NSString      *msg;

@property (nonatomic, strong) NSArray<PhotoCellData*> *data;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
