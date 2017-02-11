//
//  CCPWineryTableViewController.h
//  Baccus
//
//  Created by Carlos on 15/1/17.
//  Copyright © 2017 Carlos. All rights reserved.
//

@import UIKit;
#import "CCPWineryModel.h"

// Constantes para las secciones de los vinos
#define RED_WINE_SECTION 0
#define WHITE_WINE_SECTION 1
#define OTHER_WINE_SECTION 2

// Constantes para los mensajes
#define NEW_WINE_NOTIFICATION_NAME @"newWine"
#define WINE_KEY @"wine"

// Para la persistencia
#define SECTION_KEY @"section"
#define ROW_KEY @"row"
#define LAST_WINE_KEY @"lastWine"

@class CCPWineryTableViewController;

// Vamos a definir un protocolo
@protocol CCPWineryTableViewControllerDelegate <NSObject>

-(void) wineryTableViewController: (CCPWineryTableViewController *)wineryVC didSelectWine:(CCPWineModel *) aWine;

@end

@interface CCPWineryTableViewController : UITableViewController

@property (strong, nonatomic) CCPWineryModel *model;
@property (weak, nonatomic) id<CCPWineryTableViewControllerDelegate> delegate;

-(id) initWithModel: (CCPWineryModel *) aModel
              style: (UITableViewStyle) aStyle;

- (CCPWineModel *) lastSelectedWine;

@end
