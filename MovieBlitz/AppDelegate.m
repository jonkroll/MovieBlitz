//
//  AppDelegate.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/1/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "FlurryAnalytics.h"

#define kFlurryAnalyticsApplicationKey @"MKV8VZVGBJAEL22L4JGJ" // TODO: change to production key before uploading to app store

@interface AppDelegate()

// private methods
- (NSManagedObjectContext*)createContext;
void uncaughtExceptionHandler(NSException *exception);


@end

@implementation AppDelegate


@synthesize appSoundPlayer = _appSoundPlayer;
@synthesize window = _window;
@synthesize context = _context;

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // initialize data analytics collection
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:kFlurryAnalyticsApplicationKey];
    
    
    // preload sounds
    VKRSAppSoundPlayer *aPlayer = [[VKRSAppSoundPlayer alloc] init];
    [aPlayer addSoundWithFilename:@"click" andExtension:@"wav"];
    [aPlayer addSoundWithFilename:@"pop2" andExtension:@"wav"];
    [aPlayer addSoundWithFilename:@"ding" andExtension:@"wav"];
    [aPlayer addSoundWithFilename:@"bummer" andExtension:@"wav"];
    self.appSoundPlayer = aPlayer;
    
    
    // install default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MovieBlitz.sqlite"];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"MovieBlitz" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:path error:NULL];
        }
    }
    
    // create user defauls if they don't exist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults stringForKey:@"sounds"]) {

        [defaults setObject:@"on" forKey:@"sounds"];
        
        // save defaults
        [defaults synchronize];
    }    
 
    _context = [self createContext];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Core Data methods

- (NSManagedObjectContext*)createContext
{    
    NSManagedObjectContext *objContext;
    NSError *error;
    
    // Path to data file
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MovieBlitz.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // Init the model, coordinator, context
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                  configuration:nil 
                                                            URL:url 
                                                        options:nil 
                                                          error:&error]) {
        NSLog(@"Error: %@", [error localizedFailureReason]);
    } else {
        objContext = [[NSManagedObjectContext alloc] init];
        [objContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }

    return objContext;    
}

#pragma mark -

- (void)playSound:(NSString *)sound
{    
    NSLog(@"playing sound: %@",sound);
    
    [self.appSoundPlayer playSound:sound];
}

#pragma mark -

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@end
