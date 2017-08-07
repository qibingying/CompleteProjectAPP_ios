//
//  RushCell.h
//  meituan
//
//  Created by jinzelu on 15/7/1.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//名店抢购

#import <UIKit/UIKit.h>
#import "RushDealsModel.h"

@protocol RushDelegate <NSObject>

@optional
-(void)didSelectRushIndex:(NSInteger )index;

@end


@interface RushCell : UITableViewCell

@property(nonatomic, strong) NSMutableArray *rushData;


@property(nonatomic, assign) id<RushDelegate> delegate;

@end
