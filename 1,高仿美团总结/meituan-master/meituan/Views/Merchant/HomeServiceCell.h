//
//  HomeServiceCell.h
//  meituan
//
//  Created by jinzelu on 15/7/6.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//上门下面的小方格cell

#import <UIKit/UIKit.h>
#import "HomeServiceModel.h"

@protocol HomeServiceDelegate <NSObject>

@optional
-(void)didSelectAtIndex:(NSInteger)index;

@end

@interface HomeServiceCell : UITableViewCell

@property(nonatomic, strong) NSMutableArray *homeServiceArray;
@property(nonatomic, assign) id<HomeServiceDelegate> delegate;

@end
