//
// Created by Filipp Panfilov on 18/12/15.
// Copyright (c) 2015 Example App. All rights reserved.
//

#import "BannerItem.h"

@implementation BannerItem {
    NSString *_imageName;
}

- (instancetype)initWithImageNamed:(NSString *)imageName {
    self = [super init];
    if (self) {
        _imageName = imageName;
    }

    return self;
}

+ (instancetype)itemWithImageNamed:(NSString *)imageName {
    return [[self alloc] initWithImageNamed:imageName];
}

- (UIImage *)bannerImage {
    return [UIImage imageNamed:_imageName];
}
@end