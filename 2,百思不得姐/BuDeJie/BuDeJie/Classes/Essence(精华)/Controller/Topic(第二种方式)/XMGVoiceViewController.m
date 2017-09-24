//
//  XMGVoiceViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGVoiceViewController.h"

@implementation XMGVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:[[UISwitch alloc] init]];
}

- (QBYTopicType)type
{
    return QBYTopicTypeVoice;
}
@end
