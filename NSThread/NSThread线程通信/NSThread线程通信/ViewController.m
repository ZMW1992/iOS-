//
//  ViewController.m
//  NSThread线程通信
//
//  Created by syq on 16/1/21.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)beginDownloadImage:(id)sender {
    
    [self performSelectorInBackground:@selector(createThread) withObject:nil];
}

-(void)createThread{
    
    NSURL *url = [NSURL URLWithString:@"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg"];
    NSLog(@"开始");
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"结束");
    UIImage *image = [UIImage imageWithData:data];
//    self.iamgeView.image = [UIImage imageWithData:data];
    [self.iamgeView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];//waitUntilDone:不去等待

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
