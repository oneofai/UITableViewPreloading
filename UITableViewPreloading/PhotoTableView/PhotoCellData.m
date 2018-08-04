//
//  PhotoCellData.m
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import "PhotoCellData.h"

@implementation PhotoCellData

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    /*  [Example] change property id to photoID
     *
     *  if([key isEqualToString:@"id"]) {
     *
     *      self.photoID = value;
     *      return;
     *  }
     */
}

- (void)setValue:(id)value forKey:(NSString *)key {
    // ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictionary];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat       = @"yyyy.MM.dd";
            
            NSString *tmpDateString = [_publishedAt substringToIndex:10];
//            NSDate *tmpDate         = [NSDate dateWithTimeIntervalSinceNow:tmpDateString.integerValue];
            self.dateString         = tmpDateString;
        }
    }
    return self;
}

@end


@implementation PhotoCellEntiry

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    /*  [Example] change property id to photoID
     *
     *  if([key isEqualToString:@"id"]) {
     *
     *      self.photoID = value;
     *      return;
     *  }
     */
}

- (void)setValue:(id)value forKey:(NSString *)key {
    // ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSArray class]]) {
        NSArray        *array     = value;
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            
            PhotoCellData *data = [[PhotoCellData alloc] initWithDictionary:dictionary];
            [dataArray addObject:data];
        }
        value = dataArray.copy;
    }
    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

@end

