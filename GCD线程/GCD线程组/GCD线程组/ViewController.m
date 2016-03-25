//
//  ViewController.m
//  GCD线程组
//
//  Created by syq on 16/1/22.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"
//http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@end

#define imageUrlS @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)nomalDownload:(id)sender {
    //开启两个异步任务放到全局队列中
}


//线程组下载
- (IBAction)threadGroupDownload:(id)sender {
    //定义线程组
    dispatch_group_t group = dispatch_group_create();
    //全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 开启一个异步任务放入全局队列，在线程组里-下载图片1
    __block UIImage *image1 = nil;//修改block中的局部变量，必须用__block修饰，（copy一份新的常量对局部变量）
    dispatch_group_async(group, queue, ^{
        image1 = [self downloadImageWithUrlS:imageUrlS];
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i<50; i++) {
            NSLog(@"1111111");
        }
    });
    
    //开启线程2，放入到线程组，线程组中的两个线程串行执行
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        image2 = [self downloadImageWithUrlS:imageUrlS];
        NSLog(@"2222 = %@",[NSThread currentThread]);
        for (int i = 0; i<50; i++) {
            NSLog(@"22222");
        }
    });
    
    //监听线程组中的任务
    //等group中的所有任务都执行完毕, 再回到主线程执行其他操作
    dispatch_group_notify(group, mainQueue, ^{
        NSLog(@"dispatch_group_notify -%@",[NSThread currentThread]);
        self.image1.image = image1;
        self.image2.image = image2;

    });
}

//下载图片
-(UIImage *)downloadImageWithUrlS:(NSString *)urlS{
    NSURL *url = [NSURL URLWithString:urlS];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
