//
//  ViewController.m
//  NSThread02线程同步卖票加锁
//
//  Created by syq on 16/1/21.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"
#import "CUSTTableViewController.h"
@interface ViewController ()
{
    NSLock *lock;
}
/** 剩余票数 */
@property (nonatomic, assign) int remainderTicketsCount;
//线程一代表一个售票窗口
@property (nonatomic, strong) NSThread *thread0;
@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;

@end

@implementation ViewController


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CUSTTableViewController *VC = [CUSTTableViewController new];
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 默认有100张
    self.remainderTicketsCount = 100;
    
    // 开启多条线程同时卖票
    self.thread0 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread0.name = @"售票员 A";
    //    self.thread0.threadPriority = 0.0;
    
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread1.name = @"售票员 B";
    //    self.thread1.threadPriority = 1.0;
    
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread2.name = @"售票员 C";
    //    self.thread2.threadPriority = 0.0;
    
    
    lock = [[NSLock alloc] init];

}


/**
 * 卖票
 */
- (void)saleTicket
{
    while (true) {
//        [lock lock];//加锁1
        @synchronized(self) { // 加锁(只能用一把锁)2
            // 1.先检查票数
            int count = self.remainderTicketsCount;
            if (count > 0) {//有
                // 暂停
                //[NSThread sleepForTimeInterval:0.0002];
                // 2.票数 - 1
                self.remainderTicketsCount = count - 1;
                NSThread *current = [NSThread currentThread];
                NSLog(@"%@ 卖了一张票, 剩余%d张票", current.name, self.remainderTicketsCount);
            } else {
                // 退出线程,不能被执行了就，线程死了就
                [NSThread exit];
            }
        } // 解锁1
//        [lock unlock];解锁2
    }
}

- (IBAction)beginQiangTicket:(id)sender {
    [self.thread0 start];
    [self.thread1 start];
    [self.thread2 start];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
