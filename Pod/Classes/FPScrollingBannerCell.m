//
// Created by Филипп Панфилов on 17/12/15.
// Copyright (c) 2015 babystep.tv. All rights reserved.
//

#import "FPScrollingBannerCell.h"
#import "FPScrollingBannerItem.h"


@implementation FPScrollingBannerCell {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}

- (void)configureWithScrollingBannerItem:(id<FPScrollingBannerItem>) bannerItem {
    [_imageView setImage:[bannerItem bannerImage]];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] init];
    _imageView.adjustsImageWhenAncestorFocused = YES;
    [self.contentView addSubview:_imageView];
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *imageView = _imageView;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[imageView]-30-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imageView]-15-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:views]];
}


@end