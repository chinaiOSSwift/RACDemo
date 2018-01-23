//
//  YYView.h
//  RAC基本使用
//
//  Created by 万艳勇 on 2018/1/22.
//  Copyright © 2018年 SKOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ReactiveObjC.h>

@interface YYView : UIView

@property (nonatomic, strong) RACSubject *btnClickSingal;
@end
