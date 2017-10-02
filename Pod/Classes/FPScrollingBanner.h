//
// Created by Филипп Панфилов on 17/12/15.
// Copyright (c) 2015 babystep.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FPScrollingBanner;
@protocol FPScrollingBannerItem;

@protocol FPScrollingBannerDelegate <NSObject>

- (NSUInteger)scrollingBannerNumberOfItems:(FPScrollingBanner *)scrollingBanner;
- (UICollectionViewCell *)scrollingBanner:(FPScrollingBanner *)scrollingBanner cellForItemAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView;

@optional
- (void)scrollingBanner:(FPScrollingBanner *)scrollingBanner didSelectItemWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface FPScrollingBanner : UIView

@property (nonatomic, weak) id<FPScrollingBannerDelegate> delegate;

- (void)reloadData;

- (void)registerCellWithNib:(UINib *)nib reuseIdentifier:(NSString *)reuseIdentifier;

@end