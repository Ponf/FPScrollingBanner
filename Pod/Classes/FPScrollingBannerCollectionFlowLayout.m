//
//  FPScrollingBannerCollectionFlowLayout.m
//  gallery-test
//
//  Created by Филипп Панфилов on 13/11/15.
//  Copyright © 2015 babystep.tv. All rights reserved.
//

#import "FPScrollingBannerCollectionFlowLayout.h"

@implementation FPScrollingBannerCollectionFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    __block CGFloat offset = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x + (self.collectionView.bounds.size.width - self.itemSize.width) / 2.0;

    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);

    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];

    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        CGFloat itemOffset = attributes.frame.origin.x;
        if (fabsf((float) (itemOffset - horizontalOffset)) < fabsf((float) offset)) {
            offset = (float)(itemOffset - horizontalOffset);
        }
    }];

    CGFloat offsetX = (float)(proposedContentOffset.x) + offset;
    return CGPointMake(offsetX, proposedContentOffset.y);
}



@end
