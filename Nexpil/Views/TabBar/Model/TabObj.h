//
//  TabObj.h
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabObj : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *imageSelected;
@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)name image:(NSString *)image imageSelected:(NSString *)imageSelected;

@end

NS_ASSUME_NONNULL_END
