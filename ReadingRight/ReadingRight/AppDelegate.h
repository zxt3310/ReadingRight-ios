//
//  AppDelegate.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/23.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

