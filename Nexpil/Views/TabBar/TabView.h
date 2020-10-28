//
//  TabView.h
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabView : UIView

- (id)initWithFrame:(CGRect)frame obj:(TabObj *)obj;
- (void)setSelected:(BOOL)isSelected;

@property (nonatomic, strong) void(^blockSelected)(TabObj *obj);

@end

NS_ASSUME_NONNULL_END
