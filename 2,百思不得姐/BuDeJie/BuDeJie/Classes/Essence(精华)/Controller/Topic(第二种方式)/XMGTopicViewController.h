//
//  XMGTopicViewController.h
//  BuDeJie
//
//  Created by xiaomage on 16/3/28.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBYTopic.h"

@interface XMGTopicViewController : UITableViewController
/** 帖子的类型 */
//g不用这个是因为不想外面修改这个type属性
//@property (nonatomic, assign, readonly) XMGTopicType type;

- (QBYTopicType)type;
@end
