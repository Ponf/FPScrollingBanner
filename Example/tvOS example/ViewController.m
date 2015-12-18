//
//  ViewController.m
//  tvOS example
//
//  Created by Filipp Panfilov on 18/12/15.
//  Copyright © 2015 Example App. All rights reserved.
//

#import <FPScrollingBanner/FPScrollingBanner.h>
#import "ViewController.h"

#import "BannerItem.h"

@interface ViewController () <FPScrollingBannerDelegate>

@end

@implementation ViewController {
    __weak IBOutlet FPScrollingBanner *_scrollingBanner;
    __weak IBOutlet UILabel *_indexLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageNames = @[@"parallaxtest_01",@"paralaxtest_02",@"paralaxtest_03"];
    NSMutableArray *dataSource = @[].mutableCopy;
    [imageNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [dataSource addObject:[BannerItem itemWithImageNamed:name]];
    }];
    _scrollingBanner.items = dataSource.copy;
    _scrollingBanner.delegate = self;
}

- (void)scrollingBanner:(FPScrollingBanner *)scrollingBanner didSelectItemWithIndexPath:(NSIndexPath *)indexPath {
    _indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
}


@end
