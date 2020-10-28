//
//  TabbarView.m
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import "TabbarView.h"
#import "TabView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"

@interface TabbarView ()

@property (nonatomic, strong) NSArray *tabs;

@end

@implementation TabbarView

- (id)initWithFrame:(CGRect)frame tabs:(NSArray *)tabs{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15;
    self.tabs = tabs;
    
    [self.layer setShadowColor:RGB(214, 214, 214).CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.0, 5.0)];
    [self.layer setShadowOpacity:1.0];
    [self.layer setShadowRadius:15.0];
    
    float x = 0;
    float y = 0;
    float width = (float)(frame.size.width/tabs.count);
    float height = frame.size.height;
    for (TabObj *obj in tabs) {
        NSInteger index = [tabs indexOfObject:obj];
        x = index * width;
        CGRect rect = CGRectMake(x, y, width, height);
        __block TabView *tabView = [[TabView alloc]initWithFrame:rect obj:obj];
        tabView.tag = index;
        [self addSubview:tabView];
        [tabView setBlockSelected:^(TabObj * _Nonnull obj) {
            NSLog(@"%@", obj.name);
            for (TabView *childView in self.subviews) {
                [childView setSelected:NO];
            }
            [tabView setSelected:YES];
            if (self.blockSelected) {
                self.blockSelected(obj);
            }
        }];
    }
    
    return self;
}
- (void)setSelectedIndex:(NSInteger)index{
    for (TabView *tabView in self.subviews) {
        if (tabView.tag == index) {
            [tabView setSelected:YES];
            break;
        }
    }
}

@end
