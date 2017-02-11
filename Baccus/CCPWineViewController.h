//
//  CCPWineViewController.h
//  Baccus
//
//  Created by Carlos on 16/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

@import UIKit;
#import "CCPWineModel.h"
#import "CCPWineryTableViewController.h"

@interface CCPWineViewController : UIViewController <UISplitViewControllerDelegate, CCPWineryTableViewControllerDelegate>

@property (strong, nonatomic) CCPWineModel *model;

// IB - Interface Builder. Es la propiedad de la vista
// Siempre vienen como weak
// IBOutlet: para visualizaciones sencillas
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *grapesLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

// Añadimos este botón para que se pueda pulsar (o no) si tiene cargada la web
@property (weak, nonatomic) IBOutlet UIButton *webButton;

// IBOutletCollection: para colecciones o arrays de objetos
// como la valoración en estrellas o copas
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingViews;

/*
@property (strong, nonatomic) NSURL * wineCompanyWeb;
*/

-(id) initWithModel: (CCPWineModel *) aModel;

// IBAction: para mansar mensajose desde el botón al target
-(IBAction)displayWeb:(id)sender;

@end
