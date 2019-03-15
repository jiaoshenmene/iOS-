//
//  LockStudy.m
//  iOSInterView
//
//  Created by 杜甲 on 2019/3/15.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "LockStudy.h"

@implementation LockStudy


- (void)lockCondition {
    //主线程中
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:1];
        NSLog(@"线程1");
        sleep(2);
        [lock unlockWithCondition:3];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//以保证让线程2的代码后执行
        if ([lock tryLockWhenCondition:0]) {
            NSLog(@"线程2");
            [lock unlockWithCondition:2];
            NSLog(@"线程2解锁成功");
        }
        else {
            NSLog(@"线程2尝试加锁失败");
        }
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //         sleep(2);//以保证让线程2的代码后执行
 
        if ([lock tryLockWhenCondition:0]) {
            NSLog(@"线程3");
            [lock unlock];
            NSLog(@"线程3解锁成功");
        } else {
            NSLog(@"线程3尝试加锁失败");
        }
    });
    
    //线程4
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // sleep(3);//以保证让线程2的代码后执行
        
        [lock lockWhenCondition:2];
        NSLog(@"线程4");
        [lock unlockWithCondition:1];
        NSLog(@"线程4解锁成功");
        
    });
}
@end
