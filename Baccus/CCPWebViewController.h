//
//  CCPWebViewController.h
//  Baccus
//
//  Created by Carlos on 23/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

@import UIKit;
#import "CCPWineModel.h"

// Indicaremos al controlador que vamos a ser delegado de la vista
@interface CCPWebViewController : UIViewController <UIWebViewDelegate>

// Propiedad para el modelo
@property(strong, nonatomic) CCPWineModel *model;
// Propiedad para el IBOutlet
// Si no lo definimos como IBOutlet, no se verá nada porque no está referenciado
// Ahora aparece una bolita delante, indicando que tenemos que referencialo en el xib
//@property(weak, nonatomic) UIWebView *browser;
@property(weak, nonatomic) IBOutlet UIWebView *browser;
//Vamos a generar un IBOutlet para mostrar feedback de la carga
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

// Inicializador
-(id) initWithModel: (CCPWineModel *) aModel;

@end
