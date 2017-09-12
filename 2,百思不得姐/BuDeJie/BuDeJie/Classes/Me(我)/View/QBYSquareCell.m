//
//  QBYSquareCell.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/13.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYSquareCell.h"
#import "QBYSquareItem.h"
#import "UIimageView+WebCache.h"

@interface QBYSquareCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@end
@implementation QBYSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(QBYSquareItem *)item{
    _item = item;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameView.text = item.name;

}

@end
