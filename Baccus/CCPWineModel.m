//
//  CCPWineModel.m
//  Baccus
//
//  Created by Carlos on 11/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

#import "CCPWineModel.h"

@implementation CCPWineModel

/*
 Cuando creas una propiedad de sólo lectura e implementas un getter personalizado,
 como estamos haciendo con photo, el compilador da por hecho que no vas a necesitar
 una variable de instancia. En este caso no es así, y sí que necesito la variable,
 así que hay que obligarle a que la incluya. Esto se hace con la línea de @synthesize,
 con la que le indicamos que queremos una propiedad llamada photo con una variable
 de instancia llamada _photo.
 En la inmensa mayoría de los casos, esto es opcional.
 Para más info: http://cocoamental.com/2012/12/04/auto-synthesize-property-reglas-excepciones/
 */
@synthesize photo = _photo;

#pragma mark - Properties
-(UIImage *) photo{
    // Esto va a bloquear y se debería de hacer en segundo plano
    // Sin embargo, aún no sabemos hacer eso, así que de momento lo dejamos
    //_photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
    
    // Carga perezosa: solo cargo la imagen si hace falta.
    if (_photo == nil){
        // Si photo es nil pueden pasar 2 cosas
        if ([self checkFileFromCache:self.photoURL]){
            // 1. Si tenemos la foto descargada la usamos
            NSLog(@"Tenemos la foto en cache");
            // Sync: iré corregiendo cuando sepa más cosas de async
            [self updateImagePhotoFromCache: self.photoURL];
            // Async: al deslizar con el dedo y reutilizar la celda, se cargan los vinos
            //[self updateImagePhotoFromCacheAsync: self.photoURL];
        } else {
            // 2. Tenemos que descargar la foto
            _photo = [UIImage imageNamed:@"yoga-temporarily-not-available.png"];
            NSLog(@"La foto no está en caché");
            [self downloadFileToCacheAsync: self.photoURL];
        }
    }
    return _photo;
}

#pragma mark - Class methods

+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) aGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (NSUInteger) aRating
          photoURL: (NSURL *) aPhotoURL{
    
    return [[self alloc] initWithName: aName
                      wineCompanyName: aWineCompanyName
                                 type: aType
                               origin: anOrigin
                               grapes: aGrapes
                       wineCompanyWeb: aURL
                                notes: aNotes
                               rating: aRating
                             photoURL: aPhotoURL];
    
}

+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin{
    
    return [[self alloc] initWithName:aName
                      wineCompanyName:aWineCompanyName
                                 type:aType
                               origin:anOrigin];
    
}

#pragma mark - JSON
// Vamos sacando los valores del diccionario
// y vamos llenando las variables del inicializador
-(id) initWithDictionary:(NSDictionary *)aDict{
    return [self initWithName: [aDict objectForKey:@"name"]
              wineCompanyName: [aDict objectForKey:@"wineCompanyName"]
                         type: [aDict objectForKey:@"type"]
                       origin: [aDict objectForKey:@"origin"]
                       grapes: [self extractGrapesFromJSONArray:[aDict objectForKey:@"grapes"]]
               wineCompanyWeb: [NSURL URLWithString:[aDict objectForKey:@"wine_web"]]
                        notes: [aDict objectForKey:@"notes"]
                       rating: [[aDict objectForKey:@"rating"] intValue]
                     photoURL: [NSURL URLWithString:[aDict objectForKey:@"picture"]]
            ];
}

// Camino inverso, de CCPWineModel se pasa a diccionario
// Posterirmente con el NSSerialization se generaría el NSData
-(NSDictionary *) proxyForJSON{
    return @{
             @"name"             :   self.name,
             @"wineCompanyName"  :   self.wineCompanyName,
             @"wineCompanyWeb"   :   [self.wineCompanyWeb path],
             @"type"             :   self.type,
             @"origin"           :   self.origin,
             @"grapes"           :   self.grapes,
             @"notes"            :   self.notes,
             @"rating"           :   @(self.rating),
             @"picture"         :   [self.photoURL path]
             };
}

// Ejercicio pendiente
// Pasar de diccionario a NSData

#pragma mark - Init

// Designado
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) aGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (NSUInteger) aRating
          photoURL: (NSURL *) aPhotoURL{
    
    // Si [super init] falla, se devuelve nil y nos saltamos la inicialización
    // Si [super init] funciona, se devuelve el puntero al objeto
    if (self = [super init]){
        // Asignamos los parámetros a las variables de instancia
        // --------------------------------------------------------------------
        // OJO: Si modificamos los inicializadores puede que el objeto no esté creado
        // y puede generar errores si se hace así aunque sea correcto
        // En cualquier otro caso, se recomienda esta nomenclatura, menos al inicializar
        // self.name = aName;
        // [self setName:aName];
        // IMPORTANTE: Acostumbrarse a la siguiente nomenclatura
        // Al inicializar el objeto, acceder directamente a las variables de la instancia
        _name = aName;
        _wineCompanyName = aWineCompanyName;
        _type = aType;
        _origin = anOrigin;
        _grapes = aGrapes;
        _wineCompanyWeb = aURL;
        _notes = aNotes;
        _photoURL = aPhotoURL;
        _rating = aRating;
    }
    
    // Hasta que no devolvemos algo, se muestra un error
    return self;
    
}

// De conveniencia
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin{
    
    // Este marrón se lo come el designado
    // if(self = [super init]){}
    
    // Tan sólo devolvemos los valores
    // OJO: con los valores a nil, y con los NO_VALORES (no es lo mismo un 0 en rating, que un NO_RATING)
    // Si se asignan NO_VALORES tenemos que modificar ...
    return [self initWithName:aName
              wineCompanyName:aWineCompanyName
                         type:aType
                       origin:anOrigin
                       grapes:nil
               wineCompanyWeb:nil
                        notes:nil
                       rating:NO_RATING // OJO que no existe esta variable y hay que crearla
                     photoURL:nil];
    
}

-(NSString *) description{
    return [NSString stringWithFormat:@"‹%@\nName: %@\nType: %@\nCompany Name: %@\nNotes: %@\nOrigin: %@\nRating: %lu \nGrapes:%@\nCompany Web: %@\nPhoto Url: %@›",[self class], [self name], [self type], [self wineCompanyName], [self notes], [self origin], (unsigned long)[self rating], [self grapes], [self wineCompanyWeb], [self photoURL]];
}

#pragma mark - Utils
-(NSArray *)extractGrapesFromJSONArray: (NSArray*) JSONArray{
    
    NSMutableArray *grapes = [NSMutableArray arrayWithCapacity:[JSONArray count]];
    
    for (NSDictionary *dict in JSONArray){
        [grapes addObject:[dict objectForKey:@"grape"]];
    }
    
    return grapes;
}

-(NSArray *)packGrapesIntoJSONArray{
    
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[self.grapes count]];
    
    for (NSString *grape in self.grapes){
        [jsonArray addObject:@{@"grape": grape}];
    }
    
    return jsonArray;
}

-(BOOL)checkFileFromCache:(NSURL *) aFile{
    NSLog(@"Archivo de origen: %@", [aFile.absoluteString lastPathComponent]);
    
    //Iniciamos fileManager
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *photoFile = [aFile.absoluteString lastPathComponent];
    NSURL *url = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:photoFile];
    
    NSLog(@"Buscando en caché: %@", photoFile);
    NSError *error = nil;
    
    NSData *someData = [NSData dataWithContentsOfURL: url
                                             options: NSDataReadingMappedIfSafe
                                               error: &error];
    
    // Esperemos que no haya fallos, y que actualice la foto
    if (someData == nil){
        // Foto no disponible
        NSLog(@"Foto no disponible: %@ - Error: %@", photoFile, error.localizedDescription);
        return false;
    } else {
        // Foto diponible
        NSLog(@"Foto disponible: %@", photoFile);
        return true;
    }
    
}

-(void)downloadFileToCacheAsync: (NSURL *) aFile{
    
    NSLog(@"Async - Archivo de origen: %@", [aFile.absoluteString lastPathComponent]);
    
    // Pedimos una cola libre
    dispatch_queue_t downloadPhoto = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Lanzamos un bloque en segundo plano
    dispatch_async(downloadPhoto, ^{
        // Comienza la descarga en segundo plano
        NSData *dataFrom = [NSData dataWithContentsOfURL:aFile];
        // Visualizamos la imagen en la cola principal cuando termina
        dispatch_async(dispatch_get_main_queue(), ^{
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *photoFile = [aFile.absoluteString lastPathComponent];
            NSURL *urlTo = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
            urlTo = [urlTo URLByAppendingPathComponent:photoFile];
            
            // Guardamos el archivo en cache
            BOOL rc = NO;
            rc = [dataFrom writeToURL:urlTo atomically:YES];
            if (rc == NO){
                // Ha habido un error
                NSLog(@"Error al guardar foto: %@", photoFile);
            } else {
                NSLog(@"Guardada la foto: %@", photoFile);
                //Cuando tenemos la foto descargada, mandamos notificación al controlador
                NSNotification *n = [NSNotification notificationWithName: WINE_CHANGE_PHOTO_NOTIFICATION_NAME
                                                                  object: self
                                                                userInfo: @{WINE_PHOTO_KEY: self}];
                [[NSNotificationCenter defaultCenter] postNotification: n];
            }
        });
    });
}

-(BOOL)downloadFileToCache: (NSURL *) aFile{
    
    NSLog(@"Archivo de origen: %@", [aFile.absoluteString lastPathComponent]);
    
    NSError *error = nil;
    NSData *dataFrom = [NSData dataWithContentsOfURL:aFile
                                          options:kNilOptions
                                            error:&error];
    if(dataFrom == nil){
        // No se puede cargar la foto de la web
        return false;
    } else {
        
        //Iniciamos fileManager
        NSFileManager *fm = [NSFileManager defaultManager];
        //NSString *photoFile = [[aFile URLByDeletingPathExtension] absoluteString];
        NSString *photoFile = [aFile.absoluteString lastPathComponent];
        NSURL *urlTo = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
        urlTo = [urlTo URLByAppendingPathComponent:photoFile];
        
        // Guardamos el archivo en cache
        BOOL rc = NO;
        
        rc = [dataFrom writeToURL: urlTo
                          options: kNilOptions
                            error: &error];
        
        if (rc == NO){
            // Ha habido un error
            NSLog(@"Error al guardar foto: %@ - Error: %@", photoFile, error);
            return false;
        } else {
            NSLog(@"Foto guardada: %@", photoFile);
            return true;
        }
    }
}

-(void)updateImagePhotoFromCacheAsync: (NSURL *) aFile{
    
    NSLog(@"Async - Cargamos desde cache el archivo: %@", [aFile.absoluteString lastPathComponent]);

    
    // Pedimos una cola libre
    dispatch_queue_t loadPhoto = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Lanzamos un bloque en segundo plano
    dispatch_async(loadPhoto, ^{
        // Comienza la carga en segundo plano
        //Iniciamos fileManager
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *photoFile = [aFile.absoluteString lastPathComponent];
        NSURL *url = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:photoFile];
        
        _photo = [UIImage imageWithData:[NSData dataWithContentsOfURL: url]];
        
        // Visualizamos la imagen en la cola principal cuando termina
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_photo){
                NSLog(@"Encuentra foto en cache: %@", photoFile);
            }
            
            // El modelo envía un mensaje al controlador para que refresque la foto
            NSNotification *n = [NSNotification notificationWithName: WINE_CHANGE_PHOTO_NOTIFICATION_NAME
                                                              object: self
                                                            userInfo: @{WINE_PHOTO_KEY: self}];
            [[NSNotificationCenter defaultCenter] postNotification: n];
            
        });
    });
}

-(void)updateImagePhotoFromCache: (NSURL *) aFile{

    NSLog(@"Cargamos desde cache el archivo: %@", [aFile.absoluteString lastPathComponent]);
    
    //Iniciamos fileManager
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *photoFile = [aFile.absoluteString lastPathComponent];
    NSURL *url = [[fm URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:photoFile];
    
    _photo = [UIImage imageWithData:[NSData dataWithContentsOfURL: url]];
    
    if (_photo){
        NSLog(@"Encuentra foto en cache: %@", photoFile);
    }
}

@end
