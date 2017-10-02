//
// Created by Филипп Панфилов on 17/12/15.
// Copyright (c) 2015 babystep.tv. All rights reserved.
//

#import "FPScrollingBanner.h"
#import "FPScrollingBannerCollectionFlowLayout.h"
#import "FPScrollingBannerCell.h"

NSString * const kFPScrollingBannerCellReuseIdentifier = @"kFPScrollingBannerCellReuseIdentifier";

@interface FPScrollingBanner () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation FPScrollingBanner {
    UICollectionView *_collectionView;
}

- (void)awakeFromNib {
    [self setupCollectionView];
    [self setupConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCollectionView];
        [self setupConstraints];
    }
    return self;
}

- (UIView *)preferredFocusedView {
    return _collectionView;
}

- (void)reloadData {
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[_delegate scrollingBannerNumberOfItems:self] inSection:0]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
    [_collectionView setNeedsFocusUpdate];
    [_collectionView updateFocusIfNeeded];
}

- (void)registerCellWithNib:(UINib *)nib reuseIdentifier:(NSString *)reuseIdentifier {
    [_collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_delegate scrollingBannerNumberOfItems:self] * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<FPScrollingBannerDelegate> delegate = _delegate;
    NSIndexPath *originalIndexPath = [NSIndexPath indexPathForRow:(indexPath.row % [delegate scrollingBannerNumberOfItems:self]) inSection:0];
    return [delegate scrollingBanner:self cellForItemAtIndexPath:originalIndexPath inCollectionView:_collectionView];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    if (!context.nextFocusedIndexPath) {
        //Allowing to leave UICollectionView
        return YES;
    }
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
        NSIndexPath *originalIndexPath = [NSIndexPath indexPathForRow:(indexPath.row % [delegate scrollingBannerNumberOfItems:self]) inSection:0];
        [delegate scrollingBanner:self didSelectItemWithIndexPath:originalIndexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self centeredIndexPath].row;
    NSInteger targetIndex = currentIndex;
    NSUInteger originalItemsCount = [_delegate scrollingBannerNumberOfItems:self];
    //If we closer to edge of DataSource, scrolling to other side of collection without animation
    if (currentIndex < originalItemsCount) {
        targetIndex = currentIndex + originalItemsCount;
    }
    else if (currentIndex > (originalItemsCount * 2 - 1)) {
        targetIndex = currentIndex - originalItemsCount;
    }

    if (targetIndex != currentIndex) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_collectionView setNeedsFocusUpdate];
        [_collectionView updateFocusIfNeeded];
    }
}


#pragma mark - Private

- (void)setupCollectionView {
    self.backgroundColor = [UIColor clearColor];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:[self bannerFlowLayout]];
    [_collectionView registerClass:[FPScrollingBannerCell class] forCellWithReuseIdentifier:kFPScrollingBannerCellReuseIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.clipsToBounds = NO;
    [self addSubview:_collectionView];
}

- (FPScrollingBannerCollectionFlowLayout *)bannerFlowLayout {
    FPScrollingBannerCollectionFlowLayout *layout = [[FPScrollingBannerCollectionFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(1120, 600);
    layout.minimumInteritemSpacing = 40.0f;
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