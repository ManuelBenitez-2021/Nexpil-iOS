//
//  TabView.m
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import "TabView.h"
#import "Constant.h"

@interface TabView ()

@property (nonatomic, strong) TabObj *obj;

@property (nonatomic, strong) UIButton *btn;

@end

@implementation TabView

- (id)initWithFrame:(CGRect)frame obj:(TabObj *)obj{
    self = [super initWithFrame:frame];
    
    self.obj = obj;
    [self addSubview:self.btn];
    [self setSelected:NO];
    
    return self;
}
- (void)setSelected:(BOOL)isSelected{
    [self.btn setSelected:isSelected];
    UIImage *image = [self.obj.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIColor *color = RGB(180, 180, 180);
    if (isSelected) {
        image = [self.obj.imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
        color = RGB(56, 211, 226);
    }
    [self.btn setImage:image forState:UIControlStateNormal];
    self.btn.tintColor = color;
}
- (UIButton *)btn{
    if (!_btn) {
        float margin = 0;
        float x = 0;
        float y = margin;
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(x, y, width, height);
        _btn.contentMode = UIViewContentModeScaleAspectFit;
        [_btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
- (void)btnTap{
    if (self.blockSelected) {
        self.blockSelected(self.obj);
    }
}

@end
