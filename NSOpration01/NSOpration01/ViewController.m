//
//  ViewController.m
//  NSOpration01
//
//  Created by syq on 16/1/22.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self beginOperationQueue];
}



- (void)beginInvocationOperation
{
    // 1.创建操作对象, 封装要执行的任务
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    // 2.执行操作(默认情况下, 如果操作没有放到队列queue中, 都是同步执行)
    [operation start];
}

//2.
- (void)beginBlockOperation
{
    // 1.封装操作
//        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//            NSLog(@"NSBlockOperation1111---%@", [NSThread currentThread]);//main主线程
//        }];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    //可以开启三个线程
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation11111---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation2222222---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation33333333---%@", [NSThread currentThread]);
    }];
    
//    // 2.执行操作
    [operation start];
}





/**
 *  3.
 */
- (void)beginOperationQueue
{
    // 1.封装操作
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"NSBlockOperation------33333333333---%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.1];
        }
    }];
    // 2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2; // 最大并发数。可以开启几个线程
    
    // 设置依赖
    [operation2 addDependency:operation3];//3执行完才能执行2
    [operation3 addDependency:operation1];//1执行完才能执行3
    
    // 3.添加操作到队列中(自动执行操作, 自动开启线程)
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
}


- (void)download
{
    for (int i = 0; i<10; i++) {
        NSLog(@"------download1111111---%@", [NSThread currentThread]);
        //可以让当前线程休眠
                [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)download2
{
    for (int i = 0; i<10; i++) {
        NSLog(@"------2222222222222222---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
