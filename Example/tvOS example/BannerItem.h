//
// Created by Filipp Panfilov on 18/12/15.
// Copyright (c) 2015 Example App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FPScrollingBanner/FPScrollingBannerItem.h>


@interface BannerItem : NSObject<FPScrollingBannerItem>
- (instancetype)initWithImageNamed:(NSString *)imageName;

+ (instancetype)itemWithImageNamed:(NSString *)imageName;
@end