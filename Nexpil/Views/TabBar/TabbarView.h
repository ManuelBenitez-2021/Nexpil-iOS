//
//  TabbarView.h
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabbarView : UIView


@property (nonatomic, strong) void(^blockSelected)(TabObj *obj);

- (id)initWithFrame:(CGRect)frame tabs:(NSArray *)tabs;
- (void)setSelectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
