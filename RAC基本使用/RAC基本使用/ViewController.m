//
//  ViewController.m
//  RAC基本使用
//
//  Created by 万艳勇 on 2018/1/22.
//  Copyright © 2018年 SKOrganization. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import <NSObject+RACKVOWrapper.h>
#import "YYView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet YYView *yyView;
@property (weak, nonatomic) IBOutlet UIButton *viewBtn;
@property (weak, nonatomic) IBOutlet UITextField *viewTF;


@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, assign) int time;
@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初体验
    // [self Demo1];
    
    // 2.代理
    //[self Demo2];
    
    // 3.KVO
    //[self Demo3];
    
    // 4.按钮点击
    //[self Demo4];
    
    // 通知
    // [self Demo5];
    
    //文本输入框
    //[self Demo6];
    
    
    // Timer
    //[self Demo7];
    
    // RAC - Timer
    [self Demo8];
    
}
/**第一个Demo*/
- (void)Demo1{
    // 1.创建一个信号
    // 1.1 创建一个数组
    RACSubject *subject = [RACSubject subject];
    // 2.订阅信号 --- 函数式编程思想 ---- 谁对这个信号感兴趣,就订阅一下
    // 2.1 创建订阅者,将Block保存到订阅者对象中,将订阅者保存到数组中
    [subject subscribeNext:^(id  _Nullable x) {
        // 回调
        NSLog(@"收到了---%@",x);
    }];
    // 3.发送信号
    // 3.1
    [subject sendNext:@"哈哈"];
}

/**代理*/
- (void)Demo2{
    //代理:
    // 代理_内部:
    // 1.定义协议
    // 2.协议方法
    // 3.定义代理属性(copy)
    // 4.看看代理属性有没有值! 有没有相应我的协议方法!
    
    //代理_外部:
    // 1.设置代理
    // 2.遵守协议
    // 3.实现协议方法
    // 第一种通过传递信号来实现
    [self.yyView.btnClickSingal subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一种实现方式:%@",x);
    }];
    
    // 第二种通过方法名 来实现
    [[self.yyView rac_signalForSelector:@selector(send:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"第二种实现方式:按钮点击了---%@",x);
    }];
    
}

/**KVO 需要单独导入头文件:#import <NSObject+RACKVOWrapper.h>*/
- (void)Demo3{
    // 1.系统原生的
    [self.yyView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    // 2.RAC-KVO
    [self.yyView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        // 回调
    }];
    
    // 3.RAC-KVO frame包装成信号, 然后订阅就可以了
    [[self.yyView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

- (void)dealloc{
    [self.yyView removeObserver:self forKeyPath:@"frame"];
}

/**按钮点击*/
- (void)Demo4{
    // 监听事件
    [[self.viewBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"x-----%@",x);
    }];
}

/**通知*/
- (void)Demo5{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]  subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"noti---%@",x);
    }];
}

/**监听文本框输入*/
- (void)Demo6{
    [self.viewTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}


/**常规Timer用法*/
- (void)Demo7{
    NSThread *thread = [[NSThread alloc]initWithBlock:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run]; // 死循环
    }];
    [thread start];
}

- (void)timeMethod{
    NSLog(@"timer 调用");
   
}




/**RAC - Timer*/
- (void)Demo8{
    [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@------%@",[NSThread currentThread], x);
    }];
}


- (IBAction)sendBtnClick:(id)sender {
    // 改变状态
    self.sendBtn.enabled = false;
    // 设置倒计时
    self.time = 10;
    // 每一秒
    _disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        if (self.time >= 0) {
            [self.sendBtn setTitle:[NSString stringWithFormat:@"%ds",self.time] forState:UIControlStateDisabled];
            self.sendBtn.enabled = false;
        }else{
            [self.sendBtn setTitle:@"点击发送" forState:UIControlStateNormal];
            self.sendBtn.enabled = true;
            [_disposable dispose];
        }
        // 减去时间
        _time --;
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





































