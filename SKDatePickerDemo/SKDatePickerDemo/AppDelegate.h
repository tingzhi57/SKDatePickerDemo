//
//  AppDelegate.h
//  SKDatePickerDemo
//
//  Created by xiw on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

