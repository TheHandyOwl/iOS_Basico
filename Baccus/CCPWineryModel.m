//
//  CCPWineryModel.m
//  Baccus
//
//  Created by Carlos on 15/1/17.
//  Copyright © 2017 Carlos. All rights reserved.
//

#import "CCPWineryModel.h"

@interface CCPWineryModel ()

// Es aquí donde partimos los arrays
// Creamos el interfaz

@property (strong, nonatomic) NSMutableArray *redWines;
@property (strong, nonatomic) NSMutableArray *whiteWines;
@property (strong, nonatomic) NSMutableArray *otherWines;

@end

@implementation CCPWineryModel

#pragma mark - Properties

-(NSUInteger) redWineCount{
    return [self.redWines count];
}
-(NSUInteger) whiteWineCount{
    return [self.whiteWines count];
}
-(NSUInteger) otherWineCount{
    return [self.otherWines count];
}

-(id) init{

    //Vamos a crear los modelos iniciales para la bodega
    if (self = [super init]){
        
        // Primero comprobamos si existe el fichero data.json
        // Si existe cargamos desde ahí
        // Si no existe lanzamos el código del tutorial
        NSData *dataJSONFromHD = nil;
        
        if((dataJSONFromHD = [self checkJSONFromHD])){
            NSLog(@"Leemos el fichero JSON y cargamos los datos de caché");
            
            NSError *error = nil;
            NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData: dataJSONFromHD
                                                                   options: kNilOptions
                                                                     error: &error];
            if (JSONObjects != nil){
                // No ha habido error
                [self JSONObjectToDictionary: JSONObjects];
            }  else {
                // Se ha producido un error al parsear el JSON
                NSLog(@"Error al parsear JSON: %@", error);
            }
        
        } else {
            NSLog(@"Si no se puede leer el fichero lo pedimos otra vez");            
            
            // Definimos aquí la conexión JSON
            NSString *wineServerURL = @"http://static.keepcoding.io/baccus/wines.json";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: wineServerURL]];
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable dataJSONFromWeb, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (dataJSONFromWeb != nil){
                    // No ha habido error
                    NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData: dataJSONFromWeb
                                                                           options: kNilOptions
                                                                             error: &error];
                    if (JSONObjects != nil){
                        // No ha habido error
                        if ([self saveJSONDataToHD:dataJSONFromWeb]){
                            //Ha ido bien
                            NSLog(@"Se ha guardado el fichero");
                        } else {
                            // Ha ido mal
                            NSLog(@"No se ha guardado el fichero");
                        }
                        [self JSONObjectToDictionary: JSONObjects];
                    }  else {
                        // Se ha producido un error al parsear el JSON
                        NSLog(@"Error al parsear JSON: %@", error);
                    }
                    
                }  else {
                    // Error al descargar los datos del servidor
                    NSLog(@"Error al descargar los datos del servidor: %@", error);
                }
            }]resume];
        }
    }
    return self;
}

-(CCPWineModel *) redWineAtIndex: (NSUInteger) index{
    return [self.redWines objectAtIndex:index];
}
-(CCPWineModel *) whiteWineAtIndex: (NSUInteger) index{
    return [self.whiteWines objectAtIndex:index];
}
-(CCPWineModel *) otherWineAtIndex: (NSUInteger) index{
    return [self.otherWines objectAtIndex:index];
}

#pragma mark - Utils

// Mi método para guardar
// Devuelve true si todo está correcto
-(BOOL) saveJSONDataToHD: (NSData *) someData{

    NSLog(@"Entra a guardar JSON.");
    
    // Ruta a la carpeta caches de la Sandbox
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"data.json"];

    NSError *error = nil;
    BOOL rc = NO;
    
    rc = [someData writeToURL: url
                  options: NSDataWritingAtomic
                    error: &error];
    
    if (rc == NO){
        // Ha habido un error
        NSLog(@"Error al guardar JSON: %@", error);
        return false;
    } else {
        return true;
    }
    
}

-(NSData *) checkJSONFromHD{
    
    NSLog(@"Entra a leer el archivo JSON.");

    // Ruta a la carpeta caches de la Sandbox
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"data.json"];
    
    NSError *error = nil;

    NSData *someData = [NSData dataWithContentsOfURL: url
                                             options: NSDataReadingMappedIfSafe
                                               error: &error];
    
    // res no es un booleano, es un objeto
    if (someData == nil){
        // Error al canto
        NSLog(@"Error al leer JSON: %@", error);
        return false;
    } else {
        return someData;
    }

}

-(void) JSONObjectToDictionary: (NSArray *) JSONObjects {
    for (NSDictionary *dict in JSONObjects){
        CCPWineModel *wine = [[CCPWineModel alloc] initWithDictionary:dict];
        
        if (wine.name){
            // Añadimos al tipo adecuado
            if ([wine.type isEqualToString:RED_WINE_KEY]){
                if (!self.redWines){
                    self.redWines = [NSMutableArray arrayWithObject:wine];
                } else {
                    [self.redWines addObject:wine];
                }
            } else if ([wine.type isEqualToString:WHITE_WINE_KEY]){
                if (!self.whiteWines){
                    self.whiteWines = [NSMutableArray arrayWithObject:wine];
                } else {
                    [self.whiteWines addObject:wine];
                }
            } else {
                if (!self.otherWines){
                    self.otherWines = [NSMutableArray arrayWithObject:wine];
                } else {
                    [self.otherWines addObject:wine];
                }
            }
        }
    }
}
@end
