//
//  PhotoCell.m
//  UITableViewPreloading
//
//  Created by Sun on 2018/8/4.
//  Copyright © 2018年 Sun. All rights reserved.
//

#import "PhotoCell.h"
#import <UIImageView+WebCache.h>


@interface PhotoCell ()

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel     *dateLabel;

@end



@implementation PhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.clipsToBounds   = YES;
    
    [self buildSubview];
}

- (void)buildSubview {
    
    
    
    self.pictureView                  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/2.7)];
    self.pictureView.contentMode      = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.pictureView];
    
    
    
    
    self.dateLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(0, Height / 2.7 - 30, Width, 30)];
    self.dateLabel.textColor          = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.dateLabel.backgroundColor    = [UIColor colorWithWhite:0.8 alpha:0.5];
    self.dateLabel.textAlignment      = NSTextAlignmentRight;
    self.dateLabel.font               = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.dateLabel];
    
    UIView *topLine                      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5)];
    topLine.backgroundColor              = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    topLine.top                       = self.dateLabel.top;
    [self.contentView addSubview:topLine];
    
    UIView *bottomLine                      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5)];
    bottomLine.backgroundColor              = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    bottomLine.bottom                       = self.dateLabel.bottom;
    [self.contentView addSubview:bottomLine];
}


- (void)loadContent {
    
#warning 加载的时候闪一下是因为下边的动画, 注释掉就不闪了
    __weak PhotoCell *wself = self;
    self.dateLabel.text = self.data.dateString;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:self.data.url] placeholderImage:nil options:SDWebImageForceTransition completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        wself.pictureView.alpha = 0;
        wself.transform         = CGAffineTransformMakeScale(0.85, 0.85);
        wself.pictureView.image = image;
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            wself.pictureView.alpha = 1.f;
            wself.transform         = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];

}


- (void)cancelAnimation {
    
    [self.pictureView.layer removeAllAnimations];
}

- (CGFloat)cellOffset {
    
    CGRect  centerToWindow     = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY            = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter       = self.superview.center;
    
    CGFloat cellOffsetY        = centerY - windowCenter.y;
    
    CGFloat offsetDig          =  cellOffsetY / self.superview.frame.size.height * 2;
    CGFloat offset             =  -offsetDig * (Height / 2.7) / 2;
    
    CGAffineTransform transY   = CGAffineTransformMakeTranslation(0, offset);
    self.pictureView.transform = transY;
    
    return offset;
}


@end
