
//
//  QBYFastLoginView.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/11.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYFastLoginView.h"

@implementation QBYFastLoginView

+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
@end
