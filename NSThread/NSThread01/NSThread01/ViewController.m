//
//  ViewController.m
//  NSThread01
//
//  Created by syq on 16/1/21.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSThread *thread1;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)dispatchThread:(id)sender {
//    [self begin:@""];//直接执行堵塞线程
    [self createThread3];
}

- (void)begin:(NSString *)para
{
    NSThread *currentThread = [NSThread currentThread];
    
    for (int i = 0; i<1000; i++) {
        NSLog(@"%@----run---%@", currentThread, para);
        if (i == 200) {
            [thread1 cancel];//取消线程
        }
    }
}
/**
 *  NSThread创建1
 *  隐式创建线程, 直接开启执行
 */
-(void)createThread1{
    
    [self performSelectorInBackground:@selector(begin:) withObject:@"createThread1"];
}
/**
 * NSThread的创建2
 * 创建完线程直接(自动)启动
 */

- (void)createThread2
{
    [NSThread detachNewThreadSelector:@selector(begin:) toTarget:self withObject:@"参数createThread2"];
}

/**
 * NSThread的创建3
 * 1> 先创建初始化线程
 * 2> start开启线程
 线程的调度优先级
 + (double)threadPriority;
 + (BOOL)setThreadPriority:(double)p;
 - (double)threadPriority;
 - (BOOL)setThreadPriority:(double)p;
 调度优先级的取值范围是0.0 ~ 1.0，默认0.5，值越大，优先级越高
 线程的名字
 - (NSString *)name;
 */
- (void)createThread3
{
    thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(begin:) object:@"createThread3:线程A"];
    thread1.name = @"线程A";
    thread1.threadPriority = 1;
    // 开启线程
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(begin:) object:@"createThread3：线程B"];
    thread2.name = @"线程B";
    // 开启线程
    [thread2 start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
