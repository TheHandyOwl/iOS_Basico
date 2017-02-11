//
//  CCPWineryTableViewController.m
//  Baccus
//
//  Created by Carlos on 15/1/17.
//  Copyright © 2017 Carlos. All rights reserved.
//

#import "CCPWineryTableViewController.h"
#import "CCPWineViewController.h"

@interface CCPWineryTableViewController ()

@end

@implementation CCPWineryTableViewController

// Este método no está predefinido
- (id)initWithModel: (CCPWineryModel *) aModel
              style: (UITableViewStyle) aStyle {
    if (self = [super initWithStyle: aStyle]){
        self.model = aModel;
        
        self.title = @"Baccus";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Color de la barra de navegación
    // Parece que el alpha no sirve
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.5
                                                                           green:0
                                                                            blue:0.13
                                                                           alpha:1];
    
    // No consigo cambiar el color del texto en el título
    // Color de los items de navegación y de los items de los botones de la barra
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Añadimos esto para que respete los márgenes
    // Se trata de desactivar la vista extendida
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == RED_WINE_SECTION) {
        return @"Red wines";
    } else if (section == WHITE_WINE_SECTION) {
        return @"White wines";
    } else {
        return @"Other wines";
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //OJO: En función de la tabla que pasa la información
    // la respuesta puede ser una u otra
    // Número de secciones
    // Si es 0 la tabla está vacía
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Número de filas, según los vinos que haya
    // En función de los tipos, pasaremos unos vinos y otros
    //return 0;
    
    // Aquí preguntaremos cuántos vimnos hay y mostraresmo esa cantidad de celdas
    if (section == RED_WINE_SECTION){
        return self.model.redWineCount;
    } else if (section == WHITE_WINE_SECTION){
        return self.model.whiteWineCount;
    } else {
        return self.model.otherWineCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Esta parte es para crear celdas cuando hace falta
    
    // Vamos a cambiar el valor sugerido @"reuseIdentifier"
    // Usaremos una cadena estática CellIdentifier que valdrá @"Cell"
    // El motivo es que pueden haber distintos tipos de celda (con/sin switch)
    static NSString *CellIdentifier = @"Cell";
    
    // Averiguamos de qué vino se trata
    CCPWineModel *wine = [self wineForIndexPath:indexPath];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Como no vamos a usar celdas personalizadas por el momento
    // podemos omitir el segundo parámetro
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        // Tenemos que crear la celda a mano
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Averiguar de qué (modelo) vino nos están hablando
    // Lo hemos averiguado arriba
    /*
    CCPWineModel *wine = nil;
    
    if (indexPath.section == RED_WINE_SECTION){
        wine = [self.model redWineAtIndex:indexPath.row];
    } else if (indexPath.section == WHITE_WINE_SECTION){
        wine = [self.model whiteWineAtIndex:indexPath.row];
    } else {
        wine = [self.model otherWineAtIndex:indexPath.row];
    }
     */
    
    //Sincronizar celda (vista) y modelo (vino)
    cell.imageView.image = wine.photo;
    cell.textLabel.text = wine.name;
    cell.detailTextLabel.text = wine.wineCompanyName;
    
    //Devolvemos finalmente la celda
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Este lo creo yo. Es para hacer algo en otra vista pasando el objeto
#pragma mark - Table View Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     Ahora llamamos a otro método para averiguar el vino
     Hemos refactorizado la selección del vino,
     que aprovechará para guardarlo en memoria para la próxima

     // Suponemos que estamos en un navigation controller
    
    CCPWineModel *wine = nil;
    
    if (indexPath.section == RED_WINE_SECTION){
        wine = [self.model redWineAtIndex:indexPath.row];
    } else if (indexPath.section == WHITE_WINE_SECTION){
        wine = [self.model whiteWineAtIndex:indexPath.row];
    } else {
        wine = [self.model otherWineAtIndex:indexPath.row];
    }
     */
    
    //Escogemos el vino seleccionado
    CCPWineModel *wine = [self wineForIndexPath:indexPath];

    // Cuando creamos el delegado esto queda obsoleto, y lo movemos de sitio
    /*
    // Creamos un controlador para dicho vino
    CCPWineViewController *wineVC = [[CCPWineViewController alloc] initWithModel:wine];
    
    // Hacemos un push al navigation controller dentro del cual estamos
    // Si no existe el navigation controller el mensaje iría a nil y se perdería
    [self.navigationController pushViewController:wineVC
                                         animated:YES];
    */
    
    [self.delegate wineryTableViewController:self
                               didSelectWine:wine];
    
    // Crear notificación
    NSNotification *n = [NSNotification notificationWithName: NEW_WINE_NOTIFICATION_NAME
                                                      object: self
                                                    userInfo: @{WINE_KEY: wine}];
    
    // Enviar la notificación
    [[NSNotificationCenter defaultCenter] postNotification: n];
    
    // Por último guarda el vino seleccionado
    [self saveLastSelectedWineAtSection:indexPath.section
                                    row:indexPath.row];
    
}

#pragma mark - Utils
- (CCPWineModel *)wineForIndexPath:(NSIndexPath *)indexPath{
    CCPWineModel *wine = nil;
    
    if (indexPath.section == RED_WINE_SECTION){
        wine = [self.model redWineAtIndex:indexPath.row];
    } else if (indexPath.section == WHITE_WINE_SECTION){
        wine = [self.model whiteWineAtIndex:indexPath.row];
    } else {
        wine = [self.model otherWineAtIndex:indexPath.row];
    }
    
    return wine;
    
}

#pragma mark - NSUserDefaults

-(NSDictionary *)setDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Por defecto, mostraremos el primero de los tintos
    NSDictionary *defaultWineCoords = @{SECTION_KEY : @(RED_WINE_SECTION), ROW_KEY : @0};
    
    // Lo asignamos
    [defaults setObject: defaultWineCoords
                 forKey: LAST_WINE_KEY];
    
    // Guardamos por si las moscas
    [defaults synchronize];
    
    return defaultWineCoords;
}

-(void) saveLastSelectedWineAtSection:(NSUInteger)section row:(NSUInteger)row{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@{SECTION_KEY : @(section),
                          ROW_KEY : @(row)}
                 forKey:LAST_WINE_KEY];
    
    // Por si acaso, que Murphy acecha
    [defaults synchronize];
    
}

-(CCPWineModel *)lastSelectedWine{
    
    NSIndexPath *indexPath = nil;
    NSDictionary *coords = nil;
    
    coords = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_WINE_KEY];
    
    if (coords == nil){
        /*
         No hay nada bajo la clave LAST_WINE_KEY.
         Esto quiere decir que es la primera vez que se llama a la App
         Ponemos un valor por defecto: el primero de los tintos
         */
        coords = [self setDefaults];
    } else {
        /*
         Ya hay algo, es decir, en algún momento se guardó
         Este else en realidad sobra, es meramente explicativo
         */
    }
    
    // Transformamos esas coordenadas en un indexPath
    indexPath = [NSIndexPath indexPathForRow:[[coords objectForKey: ROW_KEY] integerValue]
                                   inSection:[[coords objectForKey: SECTION_KEY] integerValue]];
    
    // Devolvemos el vino en cuestión
    return [self wineForIndexPath: indexPath];
}

@end
