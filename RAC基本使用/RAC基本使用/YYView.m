//
//  YYView.m
//  RAC基本使用
//
//  Created by 万艳勇 on 2018/1/22.
//  Copyright © 2018年 SKOrganization. All rights reserved.
//

#import "YYView.h"

@implementation YYView



- (RACSubject *)btnClickSingal{
    if (!_btnClickSingal) {
        _btnClickSingal = [RACSubject subject];
    }
    return _btnClickSingal;
}



- (IBAction)BtnClick:(id)sender {
    NSLog(@"点击了");
    [self.btnClickSingal sendNext:@"按钮点击了"];
    [self send:@"第二种方式"];
}

- (void)send:(id)objc{
    
}

@end
