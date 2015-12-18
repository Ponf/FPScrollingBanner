//
// Created by Филипп Панфилов on 17/12/15.
// Copyright (c) 2015 babystep.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FPScrollingBannerItem;

@interface FPScrollingBannerCell : UICollectionViewCell

- (void)configureWithScrollingBannerItem:(id <FPScrollingBannerItem>)bannerItem;

@end