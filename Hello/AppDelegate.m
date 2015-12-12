//
//  AppDelegate.m
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Parameter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application       supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //將Setting.plist複製到Documents目錄
  NSFileManager *fm =  [NSFileManager new];
  
  NSString *src = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
  NSString *dst = [NSString stringWithFormat:@"%@/Documents/Setting.plist", NSHomeDirectory()];
//  if ([fm fileExistsAtPath:dst]) {
//    [fm removeItemAtPath:dst error:nil];
//  }
//  [fm copyItemAtPath:src toPath:dst error:nil];
  
  if (![fm fileExistsAtPath:dst])
    [fm copyItemAtPath:src toPath:dst error:nil];
  
  //取得sysParameter
  NSString *urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "sysParameter"];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"lang":@"zh_TW"}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSMutableArray *ary = responseObject;
//         for (NSDictionary *dic in ary) {
           //NSLog(@"%@", [NSString stringWithFormat:@"type=%@, key=%@, value=%@", dic[@"_type"], dic[@"_key"],  dic[@"_value"]]);
//         }
         [self putParameterToCore: ary];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }
   ];

  return YES;
}

- (void) putParameterToCore:(NSMutableArray*) ary {
  //清除所有Parameter
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  //NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, key, value, nil] forKeys:[NSArray arrayWithObjects:@"type", @"key", @"value", nil]];
  NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchAllParameter"
                    substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:@"type", @"", nil]];
  
  NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
  for (Parameter *param in fetchResult) {
    [app.managedObjectContext deleteObject:param];
  }
  
  for (NSDictionary *dic in ary) {
    Parameter *coreParam;
    coreParam = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter" inManagedObjectContext:app.managedObjectContext];
    coreParam.type = dic[@"_type"];
    coreParam.key = dic[@"_key"];
    coreParam.value = dic[@"_value"];
    [app.managedObjectContext save:nil];
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
  //更改桌面icon badge
  
  /*
  float version = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (version >= 8.0) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }
  
  [UIApplication sharedApplication].applicationIconBadgeNumber = 3;
  */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  NSLog(@"enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
  NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
  
  // The directory the application uses to store the Core Data store file. This code uses a directory named "idv.derek-chou.Hello" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hello" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hello.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
