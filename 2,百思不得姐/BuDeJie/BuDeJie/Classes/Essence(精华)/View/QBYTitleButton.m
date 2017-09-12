//
//  QBYTitleButton.m
//  BuDeJie
//
//  Created by 古俊兵 on 2017/8/5.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

/*
 特定构造方法
 1> 后面带有NS_DESIGNATED_INITIALIZER的方法，就是特定构造方法
 
 2> 子类如果重写了父类的【特定构造方法】，那么必须用super调用父类的【特定构造方法】，不然会出现警告
 */

/*
 警告信息:Designated initializer missing a 'super' call to a designated initializer of the super class
 意思：【特定构造方法】缺少super去调用父类的【特定构造方法】
 */
#import "QBYTitleButton.h"

@implementation QBYTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
// 只要重写了这个方法，按钮就无法进入highlighted状态
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
