//
//  ViewController.m
//  GCD_异步下载图片常用方法
//
//  Created by syq on 16/1/21.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (IBAction)beginDownloadImage:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        //开启线程下载图片
        NSURL *url = [NSURL URLWithString:@"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *iamge = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"--imageView--%@", [NSThread currentThread]);
            self.imageView.image = iamge;
        });
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
