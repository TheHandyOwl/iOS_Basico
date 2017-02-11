//
//  CCPWineViewController.m
//  Baccus
//
//  Created by Carlos on 16/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

#import "CCPWineViewController.h"
#import "CCPWebViewController.h"

// De momento no hace falta
// Así que quitamos estas 2 líneas
// Se añadirán más adelante explicando su uso
/*
@interface CCPWineViewController ()
@end
*/

@implementation CCPWineViewController

//El controlador necesita saber 2 cosas: quién es su modelo, y quién es su vista

// Aquí se coge la vista por defecto de la clase
// que tiene el mismo nombre que el modelo
// y que está en el bundle principal
-(id) initWithModel: (CCPWineModel *) aModel{
    
    // Aquí le pasamos la vista
    if (self = [super initWithNibName:nil bundle:nil]){
        // Aquí le pasamos el modelo
        _model = aModel;
        
        // Propiedad heredada
        // Mejor usar el setter
        self.title = aModel.name;

    }
    return self;
}

// Inicialización por defecto que aparece en versiones anteriores de XCode
// Es el inicializador designado de UIViewController
// Como es el que sale por defecto, lo podemos borrar
// Sí, lo hemos creado para nada, será iniciado desde initWithModel
/*
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        //Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    // Si el controlador primario está oculto, le pasamos el botón
    // Y esta parte hay que repetirla en el splitViewController
    if(self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    }
}

// Inicialización por defecto que aparece en versiones anteriores de XCode
// Para sincronizar modelo y vista
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //La pantalla está cargada, tiene tamaño y posición, y está a punto de aparecer
    
    //Añadimos esto para que respete los márgenes
    // Se trata de desactivar la vista extendida
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Para bloquear el color de la barra poner traslúcida a NO
    //self.navigationController.navigationBar.translucent = NO;
    
    // Color de fondo para la vista
    // No parece que cambie nada
    /*
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.5
                                                                              green:0
                                                                               blue:0.13
                                                                              alpha:1];
    */
    
    // Color de la barra de navegación
    // Parece que el alpha no sirve
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.5
                                                                           green:0
                                                                            blue:0.13
                                                                           alpha:1];
    
    // No consigo cambiar el color del texto en el título
    // Color de los items de navegación y de los items de los botones de la barra
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Vamos a sincronizar vista y modelo mediante otro método que nos inventamos
    // Ver apartado Utils de abajo
    [self syncModelWithView];
    
}

// Inicialización por defecto que aparece en versiones anteriores de XCode
// Este tampoco vamos a usarlo por el momento, pero así lo conocemos
/*
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //La vista va a desaparecer
}
*/

// Todas las clases pueden reciben este tipo de mensajes a través de las notificaciones
// para liberar memoria de forma voluntaria. En caso contrario ordena apps por tamaño y empieza a matar apps
// hasta que el sistema decide que el nivel de memoria es aceptable
// Al descender de UIViewController heredan la suscripción y puede recibir mensajes por aquí
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions
-(IBAction)displayWeb:(id)sender{
    
    // Vamos a comentar este histórico
    //NSLog(@"Go to: %@", [self.model wineCompanyWeb]);
    
    // Y metemos el código para que cargue un nuevo controlador
    // desde un navigationController que carga wineVC como principal
    // y posteriormente lo mostrará
    
    // Crear un webVC
    CCPWebViewController *webVC = [[CCPWebViewController alloc] initWithModel:self.model];
    
    // Y hacemos un push
    [self.navigationController pushViewController:webVC
                                         animated:YES];
    
}

#pragma mark - Utils

-(void) syncModelWithView{
    self.nameLabel.text = self.model.name;
    self.typeLabel.text = self.model.type;
    self.originLabel.text = self.model.origin;
    self.notesLabel.text = self.model.notes;
    self.wineryNameLabel.text = self.model.wineCompanyName;
    self.grapesLabel.text = [self arrayToString: self.model.grapes];
    
    // La imagen de la dirección URL de la foto
    self.photoView.image = self.model.photo;
    
    //Array de vistas para valoración
    [self displayRating: self.model.rating];
    
    [self.notesLabel setNumberOfLines:0];
    
    // Si no hay URL, pues no activamos el botón 'info'
    self.webButton.enabled = (BOOL)self.model.wineCompanyWeb;
    
}

-(void) clearRatings{
    for (UIImageView *imgView in self.ratingViews){
        imgView.image = nil;
    }
}

-(void) displayRating: (NSUInteger) aRating{

    [self clearRatings];
    
    UIImage *glass = [UIImage imageNamed:@"splitView_score_glass"];
    
    for (NSUInteger i = 0; i < aRating; i++){
        [[self.ratingViews objectAtIndex:i] setImage:glass];
    }
}

-(NSString *) arrayToString: (NSArray *) anArray{
    
    NSString *repr = nil;
    
    if([anArray count] == 1){
        repr = [@"100% " stringByAppendingString:[anArray lastObject]];
    } else {
        repr = [[anArray componentsJoinedByString:@", "] stringByAppendingString:@"."];
    }
    return repr;
}

#pragma mark - UISplitViewControllerDelegate

-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{

    // Si el controlador primario está oculto, le pasamos el botón
    // Y esta parte hay que repetirla en el viewDidLoad
    if (displayMode ==  UISplitViewControllerDisplayModePrimaryHidden){
      self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }
}

#pragma mark - WineryTableViewControllerDelegate
-(void) wineryTableViewController:(CCPWineryTableViewController *)wineryVC
                    didSelectWine:(CCPWineModel *)aWine{
    
    self.model = aWine;
    
    //Tras el patrón delegado, tenemos que cambiar el título
    self.title = aWine.name;
    
    //Y sincronizamos la vista
    [self syncModelWithView];
}

@end
