//
// Created by Филипп Панфилов on 17/12/15.
// Copyright (c) 2015 babystep.tv. All rights reserved.
//

#import "FPScrollingBanner.h"
#import "FPScrollingBannerCollectionFlowLayout.h"
#import "FPScrollingBannerCell.h"
#import "FPScrollingBannerItem.h"

NSString * const kFPScrollingBannerCellReuseIdentifier = @"kFPScrollingBannerCellReuseIdentifier";

@interface FPScrollingBanner () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation FPScrollingBanner {
    UICollectionView *_collectionView;
    NSUInteger _originalDataSourceCount;
    NSArray *_dataSource;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    [self setupCollectionView];
    [self setupConstraints];
}

- (UIView *)preferredFocusedView {
    return _collectionView;
}

- (void)setItems:(NSArray<id<FPScrollingBannerItem>> *)items {
    _originalDataSourceCount = items.count;
    //Copying original array 3 times, result will be [a,b,c,a,b,c,a,b,c,]
    NSMutableArray *workingArray = [items mutableCopy];
    [workingArray addObjectsFromArray:items];
    [workingArray addObjectsFromArray:items];
    _dataSource = [workingArray copy];
    [_collectionView reloadData];

    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_originalDataSourceCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [_collectionView setNeedsFocusUpdate];
    [_collectionView updateFocusIfNeeded];
}

- (NSArray<id<FPScrollingBannerItem>> *)items {
    return [_dataSource subarrayWithRange:NSMakeRange(0, _originalDataSourceCount)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FPScrollingBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFPScrollingBannerCellReuseIdentifier
                                                                            forIndexPath:indexPath];
    [cell configureWithScrollingBannerItem:_dataSource[(NSUInteger) indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    NSIndexPath *visibleIndexPath = [self centeredIndexPath];
    NSIndexPath *focusingIndexPath = context.nextFocusedIndexPath;
    //Allowing to focus only on neighbor items
    BOOL shouldUpdate =  abs((int)(visibleIndexPath.row - focusingIndexPath.row)) <= 1;
    return shouldUpdate;
}

- (NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    NSIndexPath *visibleIndexPath = [self centeredIndexPath];
    return visibleIndexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<FPScrollingBannerDelegate> delegate = _delegate;
    if ([delegate respondsToSelector:@selector(scrollingBanner:didSelectItemWithIndexPath:)]){
        NSIndexPath *originalIndexPath = [NSIndexPath indexPathForRow:(indexPath.row % _originalDataSourceCount) inSection:0];
        [delegate scrollingBanner:self didSelectItemWithIndexPath:originalIndexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self centeredIndexPath].row;
    NSInteger targetIndex = currentIndex;
    //If we closer to edge of DataSource, scrolling to other side of collection without animation
    if (currentIndex < _originalDataSourceCount) {
        targetIndex = currentIndex + _originalDataSourceCount;
    }
    else if (currentIndex > (_originalDataSourceCount * 2 - 1)) {
        targetIndex = currentIndex - _originalDataSourceCount;
    }

    if (targetIndex != currentIndex) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_collectionView setNeedsFocusUpdate];
        [_collectionView updateFocusIfNeeded];
    }
}


#pragma mark - Private

- (void)setupCollectionView {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:[self bannerFlowLayout]];
    [_collectionView registerClass:[FPScrollingBannerCell class] forCellWithReuseIdentifier:kFPScrollingBannerCellReuseIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.clipsToBounds = NO;
    [self addSubview:_collectionView];
}

- (FPScrollingBannerCollectionFlowLayout *)bannerFlowLayout {
    FPScrollingBannerCollectionFlowLayout *layout = [[FPScrollingBannerCollectionFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(1740, 600);
    layout.minimumInteritemSpacing = 10.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (void)setupConstraints {
    NSCAssert(_collectionView != nil, @"Please setup _collectionView before");
    if (!_collectionView) {
        return;
    }
    UIView *collectionView = _collectionView;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:views]];
}

- (NSIndexPath *)centeredIndexPath {
    CGRect visibleRect = (CGRect){.origin = _collectionView.contentOffset, .size = _collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [_collectionView indexPathForItemAtPoint:visiblePoint];
    return visibleIndexPath;
}



@end