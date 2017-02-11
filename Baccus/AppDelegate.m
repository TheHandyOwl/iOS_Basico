//
//  AppDelegate.m
//  Baccus
//
//  Created by Carlos on 10/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

#import "AppDelegate.h"
#import "CCPWineModel.h"
#import "CCPWineViewController.h"
#import "CCPWebViewController.h"
#import "CCPWineryModel.h"
#import "CCPWineryTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Controlador por el momento
    //self.window.rootViewController = [[UIViewController alloc] init];

    /*
     Creamos el modelo
     Aquí estaban los vinos inicializados
     Se han pasado al modelo bodega para poder contarlos y demás
     */
    CCPWineryModel *winery = [[CCPWineryModel alloc] init];

    
    /*
     Creamos los controladores
     Vamos a probar el nuevo controlador que lanza un navegador
     Y necesitamos comentar este de aquí abajo
     CCPWineViewController *wineVC = [[CCPWineViewController alloc] initWithModel:tintorro];
     Y lo sustituimos por este otro
     */
    
    // Pasamos de 1 vino
    //CCPWineViewController *wineVC = [[CCPWineViewController alloc] initWithModel:tintorro];
    //CCPWebViewController *webVC = [[CCPWebViewController alloc] initWithModel:tintorro];
    
    // A tres vinos para usarlos con un combinador
    //CCPWineViewController *tintoVC = [[CCPWineViewController alloc] initWithModel:tintorro];
    //CCPWineViewController *blancoVC = [[CCPWineViewController alloc] initWithModel:albarinno];
    //CCPWineViewController *otroVC = [[CCPWineViewController alloc] initWithModel:champagne];

    // APP Universal, quitamos la dependencia de inicializar controladores
    // Quitamos toda referencia a tabs, navs, etc.
    
    /**/
    CCPWineryTableViewController *wineryVC = [[CCPWineryTableViewController alloc] initWithModel:winery style:UITableViewStylePlain];
    // Vamos a aplicar persistencia
    CCPWineViewController *wineVC = [[CCPWineViewController alloc] initWithModel:[winery redWineAtIndex:0]];
    // Cambiando el primer vino, al último vino seleccionado
    // BUG: esta opción no funciona en la última versión de xCode. Habilitamos la opción anterior
    //CCPWineViewController *wineVC = [[CCPWineViewController alloc] initWithModel:[wineryVC lastSelectedWine]];
    /**/
    
    // Creamos el combinador UITabBarController
    //UITabBarController *tabVC = [[UITabBarController alloc] init];
    //tabVC.viewControllers = @[wineVC, webVC];
    
    // Creamos el combinador UINavVC
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:wineVC];
    // Pasamos del controlador de 1 vino, a controlar 3 vinos
    /*
    UINavigationController *tintoNav = [[UINavigationController alloc] initWithRootViewController:tintoVC];
    UINavigationController *blancoNav = [[UINavigationController alloc] initWithRootViewController:blancoVC];
    UINavigationController *otroNav = [[UINavigationController alloc] initWithRootViewController:otroVC];
    */
    
    // App Universal
    // Esto también lo quitamos
    
    /**/
    UINavigationController *wineryNav = [[UINavigationController alloc] initWithRootViewController:wineryVC];
    UINavigationController *wineNav = [[UINavigationController alloc] initWithRootViewController:wineVC];
    /**/
    
    // Creamos el combinador para los 3 controladores de los 3 vinos
    /*
     UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[tintoNav, blancoNav, otroNav];
    */
    
    // App Universal
    // Esto también lo quitamos
    
    /**/
    //Creamos el split
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[wineryNav, wineNav];
    
    // Asignamos delegado
    splitVC.delegate = wineVC;
    wineryVC.delegate = wineVC;
    
    // Lo asignamos como controlador raiz
    // Al probar el nuevo controlador, ésta nomenclatura referencia al controlador anterior
    //self.window.rootViewController = wineVC;
    // Ahora vamos a probar el nuevo controlador
    //self.window.rootViewController = webVC;
    //self.window.rootViewController = tabVC;
    // Y pasamos de 1 vino
    //self.window.rootViewController = navVC;
    // A 3 vinos
    //self.window.rootViewController = tabVC;
    //self.window.rootViewController = wineryNav;
    self.window.rootViewController = splitVC;
    /**/
    
    // Tras generarse un error, creamos el controlador
    //self.window.rootViewController = [[UIViewController alloc] init];
    
    // App Universal
    // Del modelo inicial saltamos hasta aquí
    // Me lo salto porque está 'deprecated' total
    
    /*
    UIViewController *rootVC = nil;
    if (!IS_IPHONE){
        // Tableta
        rootVC = [self rootviewControllerForPadWithModel: winery];
    } else {
        rootVC = [self rootviewControllerForPhoneWithModel: winery];
    }
    self.window.rootViewController = rootVC;
    */
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor orangeColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
