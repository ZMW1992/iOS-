//
//  ViewController.m
//  线程依赖关系
//
//  Created by syq on 16/1/23.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
/*
 dispatch_barrier_async的使用
 dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //必须开启一个子线程，子线程中串行执行任务
    //代码的第一行  DISPATCH_QUEUE_CONCURRENT 代表这个queue 是并发性质的。
    dispatch_queue_t queue = dispatch_queue_create("syq", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async11111111111,%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async22222222%@",[NSThread currentThread]);
    });
    //等上面任务执行完
    dispatch_async(queue, ^{
        NSLog(@"dispatch_barrier_async333333%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:4];
        
    });
    //等待会开启新的一个线程
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async4444444%@",[NSThread currentThread]);
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
