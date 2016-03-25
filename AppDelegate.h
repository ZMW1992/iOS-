//
//  AppDelegate.h
//  ReleaseDemo
//
//  Created by syq on 16/1/22.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

//***********************************
//1.线程和进程的区别和联系
//线程是CPU独立运行和独立调度的基本单位（可以理解为一个进程中执行的代码片段)
//进程是资源分配的基本单位（进程是一块包含了某些资源的内存区域）。
//进程是线程的容器，真正完成代码执行的是线程，而进程则作为线程的执行环境。
//一个程序至少包含一个进程，一个进程至少包含一个线程，一个进程中的多个线程共享当前进程所拥有的资源.

//************************************
//2.多线程开发的优缺点
//优点:
//①使用线程可以把程序中占据时间长的任务放到后台去处理，如图片、视频的下载
//②发挥多核处理器的优势，并发执行让系统运行的更快、更流畅，用户体验更好
//缺点：
//①大量的线程降低代码的可读性，
//②更多的线程需要更多的内存空间
//③当多个线程对同一个资源出现争夺的时候要注意线程安全的问题。

//线程的使用不是无节制的
//①IOS中得主线程的堆栈大小是1M
//②从第二个线程开始都是512K
//③这些数值不能通过编译器开关或者API函数更改
//注:更新UI界面时,处理界面和用户之间的交互事件一定要在主线程中处理

//************************************

//3.多线程技术总结
//NSThread
//优点:NSThread比其他两个轻量级,使用简单
//缺点:需要自己管理线程的生命周期,线程同步,加锁,睡眠以及唤醒等,线程同步对数据的加锁会有一定的系统开销
//NSOperation
//不需要关心线程管理,数据同步的事情,可以把精力放在自己需要执行的操作上
//项目中使用NSOperation的优点是NSOperation是对线程的高度抽象，在项目中使用它，会使项目的程序结构构更好，子类化NSOperation的设计思路，是具有面向对象的优点（复用、封装），使得实现是多线程支持，而接口简单，建议在复杂项目中使用。
//NSOperation是面向对象的
//GCD
//是由苹果开发的一个多核编程的解决方案,GCD是基于C语言的
//项目中使用GCD的优点是GCD本身非常简单、易用，对于不复杂的多线程操作，会节省代码量，而Block参数的使用，会是代码更为易读，建议在简单项目中使用。

//#####################################
//①NSObject的多线程方法-对NSThread的封装（一个NSThread对象对应一条线程）
//•开启后台线程执行任务的方法
//-(void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg
//•在后台线程中通知主线程执行任务的方法
//–(void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
//•获取线程信息
//[NSThread currentThread];
//•线程休眠
//[NSThread sleepForTimeInterval:1.0f];
//提示：
//–performSelectorInBackground方法本身是在主线程中执行的，而选择器指定的方法是在后台线程中进行的
//–尽管使用performSelectorInBackground方法调用的任务可以更新UI界面，但是在实际开发中，涉及到UI界面的更新操作，还是要使用performSelectorOnMainThread方法，以避免不必要的麻烦
//注：
//•内存管理对于多线程非常重要
//•Objective-C可以凭借@autoreleasepool使用内存资源，并需要时回收资源
//•每个线程都需要有@autoreleasepool，否则可能会出现内存泄漏

//######################################
//②NSThread
//
//•创建线程方法：
//.+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
//- (id)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
//•参数说明：
//–selector：线程执行的方法，只能有一个参数，不能有返回值
//–target：selector消息发送的对象
//–argument：传输给target的唯一参数，也可以是nil

//######################################
//③NSOperation/NSOperationQueue
//
//•NSOperation的两个子类
//NSInvocationOperation
//NSBlockOperation
//
//•工作原理：
//.用NSOperation封装要执行的操作
//.将创建好的NSOperation对象放NSOperationQueue中
//.启动OperationQueue开始新的线程执行队列中的操作
//•注意事项：
//.使用多线程时通常需要控制线程的并发数，因为线程会消耗系统资源，同时运行的线程过多，系统会变慢
//.使用以下方法可以控制并发的线程数量：
//-(void)setMaxConcurrentOperationCount:(NSInteger)cnt;
//.使用addDependency可以建立操作之间的依赖关系，设定操作的执行顺序
//上面的程序设置依赖关系后，只有等操作a和b都执行完,才会执行c.

//######################################
//④GCD
//•GCD队列：
/*
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
//************************************
//4.RunLoop
//一个RunLoop就是一个事件处理的循环，用来不停的调度工作以及处理输入事件。使用runloop的目的是让你的线程在有工作的时候忙于工作,而没工作的时候处于休眠状态。runloop的设计是为了减少cpu无谓的空转。