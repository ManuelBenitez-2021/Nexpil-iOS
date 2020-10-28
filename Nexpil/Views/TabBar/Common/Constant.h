//
//  Constant.h
//  TabbarController
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define FONT_BOLD               @"Montserrat-Bold"
#define FONT_MEDIUM             @"Montserrat-Medium"
#define FONT_REGULAR            @"Montserrat-Regular"
#define FONT_ALTERNATES_BOLD    @"MontserratAlternates-Bold"

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0f]
#define RGBA(x,y,z,a) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:a]

@interface Constant : NSObject

@end

NS_ASSUME_NONNULL_END
