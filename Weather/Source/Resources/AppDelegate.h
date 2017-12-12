//
//  AppDelegate.h
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

