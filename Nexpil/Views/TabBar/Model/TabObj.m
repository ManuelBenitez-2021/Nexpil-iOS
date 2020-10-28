//
//  TabObj.m
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import "TabObj.h"

@implementation TabObj

- (id)initWithName:(NSString *)name image:(NSString *)image imageSelected:(NSString *)imageSelected{
    self = [super init];
    
    self.name = name;
    self.image = [UIImage imageNamed:image];
    self.imageSelected = [UIImage imageNamed:imageSelected];
    
    return self;
}

@end
