//
//  CCPWineModel.h
//  Baccus
//
//  Created by Carlos on 11/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

@import Foundation;
@import UIKit;

#define NO_RATING -1

// Voy a crear un mensaje para indicar que se cargue nuevamente la foto
#define WINE_CHANGE_PHOTO_NOTIFICATION_NAME @"changePhoto"
#define WINE_PHOTO_KEY @"aWine"

@interface CCPWineModel : NSObject

//Propiedades
@property (strong, nonatomic) NSString *type; // Tipo de vino
// Al adaptar las propiedades a JSON vemos que esta es de sólo lectura (???)
@property (strong, nonatomic, readonly) UIImage *photo; // Es la clase que representa una imágen, no es la imágen en sí
@property (strong, nonatomic) NSURL *photoURL; // Añadimos esta propiedad para descargar la imagen tras JSON
@property (strong, nonatomic) NSURL *wineCompanyWeb; // Clase que comprueba que la URL existe
@property (strong, nonatomic) NSString *notes; //Descripción del vino
@property (strong, nonatomic) NSString *origin; // Denominación de origen
@property (nonatomic) NSUInteger rating; // Nota de 0 a 5. OJO: no es un objeto y no lleva puntero
@property (strong, nonatomic) NSArray *grapes; // Monovarietal (una o más uvas)
@property (strong, nonatomic) NSString *name; // Nombre del vino
@property (strong, nonatomic) NSString *wineCompanyName; // Nombre de la bodega

// Métodos de clase (+)
// -------------------------

// Constructores de conveniencia
+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) aGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (NSUInteger) aRating
             //photo: (UIImage *) aPhoto // En JSON quitamos esta propiedad
          photoURL: (NSURL *) aPhotoURL;

+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin;


// Métodos de instancia (-)
// -------------------------

// Designado
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) aGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (NSUInteger) aRating
             //photo: (UIImage *) aPhoto // En JSON quitamos esta propiedad
          photoURL: (NSURL *) aPhotoURL;

// De conveniencia
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin;

// Inicializador a partir de diccionario JSON
-(id) initWithDictionary: (NSDictionary *) aDict;

@end
