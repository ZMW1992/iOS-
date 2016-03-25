//
//  ViewController.m
//  GCD_1
//
//  Created by syq on 16/1/21.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//


/*
 什么是GCD
 全称是Grand Central Dispatch，可译为“重要的中枢调度器”
 纯C语言
 GCD的优势
 GCD会自动利用更多的CPU内核
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 
 
 GCD中有2个核心概念
 任务：执行什么操作
 队列：用来存放任务
 
 GCD的使用就2个步骤
 定制任务
 确定想做的事情
 
 将任务添加到队列中
 GCD会自动将队列中的任务取出，放到对应的线程中执行
 任务的取出遵循队列的FIFO原则：先进先出，后进后出
 
 GCD中有2个用来执行任务的函数
 用同步的方式执行任务
 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
 queue：队列
 block：任务
 
 用异步的方式执行任务
 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 
 同步和异步的区别
 同步：在当前线程中执行
 异步：在另一条线程中执行
 
 同步和异步决定了要不要开启新的线程
 同步：在当前线程中执行任务，不具备开启新线程的能力
 异步：在新的线程中执行任务，具备开启新线程的能力
 
 并发和串行决定了任务的执行方式
 并发：多个任务并发（同时）执行
 串行：一个任务执行完毕后，再执行下一个任务
 
 
 1.全局队列
 使用dispatch_get_global_queue函数获得全局的并发队列
 //参数1：优先级   参数2：暂时无用 0
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获得全局并发队列
 

 2.自定义队列：可以开启新线程，任务串行执行）(控制队列并发或者串行)
 使用dispatch_queue_create函数创建串行队列
 //参数1：队列名称
 //参数2：队列属性，一般用NULL：开启一个串行队列，任务会串行执行（开启一个子线程可以）
                如果为DISPATCH_QUEUE_CONCURRENT 则创建的是Concurrent queue：并发队列，每个任务开启一个子线程并发执行

 dispatch_queue_t queue = dispatch_queue_create("cn.syq.queue", NULL); // 创建1
 dispatch_queue_t queue = dispatch_queue_create("cn.syq.queue", DISPATCH_QUEUE_CONCURRENT); // 创建2

主队列
 使用主队列（跟主线程相关联的队列）
 主队列是GCD自带的一种特殊的串行队列
 放在主队列中的任务，都会放到主线程中执行
 使用dispatch_get_main_queue()获得主队列
 dispatch_queue_t queue = dispatch_get_main_queue();
 
 
 
 总结：
 同步（sync）：不会开启新线程
 
 异步（async）：
    *全局并发队列：
        有开启新线程
        并发执行任务
 
    *主队列：
        没有开启新线程，串行执行任务
    *自定义队列：
        有开启新线程，串行执行任务

 


 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%@",[NSThread currentThread]);
    [self asyncSerialQueue];
}
//开启一个异步子线程
-(void)GCDChildThread{
    //获得全局队列
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //添加异步任务到主队列
    dispatch_async(global_queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
}

/**
 * 使用dispatch_async异步函数, 在主线程中往主队列中添加任务
 */
- (void)beginAsyncMainQueue
{
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.添加任务到队列中 执行
    dispatch_async(queue, ^{
        NSLog(@"-----%@", [NSThread currentThread]);
        for (int i = 0; i < 1000; i++) {
            NSLog(@"global_queue");
        }
    });
    //等我的当前打印完成-》执行主队列“异步”（并非异步）任务
    for (int i = 0; i < 1000; i++) {
        NSLog(@"dafdasfadafasdfasfafafdsafdasfda");
    }
}

/**
 * 使用dispatch_sync同步函数, 在主线程中往主队列中添加任务 : 任务无法往下执行,造成互相等待，谁也无法执行
 */
- (void)beginSyncMainQueue
{
    // 1.获得主队列（同步要等待，自身主队列互相等待）
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 2.添加同步任务到队列中 执行
    dispatch_sync(queue, ^{
        NSLog(@"---------%@", [NSThread currentThread]);
    });
    //该行不能执行，上面互相等待
    NSLog(@"互相等待，不能被打印");
}


/**
 * 用dispatch_sync往自定义队列列中添加任务
 // 总结: 不会开启新的线程

 */
- (void)syncSerialQueue
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("shenYingQiang", NULL);
    
    // 2.添加任务到队列中 执行
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片3-----%@", [NSThread currentThread]);
    });
}

/**
 * 用dispatch_sync同步任务 -》全局队列中添加任务
 // 总结: 不会开启新的线程

 */
- (void)syncGlobalQueue
{
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.添加任务到队列中 执行
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----下载图片3-----%@", [NSThread currentThread]);
    });
}


/**
 * 用dispatch_async异步任务-》往自定义队列中添加任务
 
 // 总结: 只开1个线程执行任务,每个任务同步执行。。。。
    11111打印中是线程2      .。。跟4444主线程打印异步
 ////第二个参数为Null 创建Serial dispatch queue;
 如果为DISPATCH_QUEUE_CONCURRENT 则创建的是Concurrent queue;

 */
- (void)asyncSerialQueue
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("syqsyq", NULL);
    // 2.添加任务到队列中 执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 50; i++) {
            NSLog(@"----1111111111-----%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 50; i++) {
            for (int i = 0; i < 100; i++) {
                NSLog(@"----22222222-----%@", [NSThread currentThread]);
            }
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 50; i++) {
            NSLog(@"----333333-----%@", [NSThread currentThread]);
        }
    });
    for (int i = 0; i < 100; i++) {
        NSLog(@"----444444444-----%@", [NSThread currentThread]);
    }
}


/**
 * 用dispatch_async异步任务往 -》自定义队列中添加任务
 *终于可以正常开启线程了，，，，也就是经常用的
 // 总结: 同时开启了3个线程

 */
- (void)beginAsyncGlobalQueue
{
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.添加任务到队列中 执行
    dispatch_async(queue, ^{
        NSLog(@"---11111-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----22222-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----33333333-----%@", [NSThread currentThread]);
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
