//
//  CCPWineryModel.h
//  Baccus
//
//  Created by Carlos on 15/1/17.
//  Copyright © 2017 Carlos. All rights reserved.
//

@import Foundation;
#import "CCPWineModel.h"

#define RED_WINE_KEY    @"Tinto"
#define WHITE_WINE_KEY  @"Blanco"
#define OTHER_WINE_KEY  @"Rosado"

@interface CCPWineryModel : NSObject

// Vamos a tener 3 tipos de vino
// Pero es una forma de ensuciar o liar la clase
// La forma de implementearla debería ser indiferente
// Eso se puede hacer en el .m y no aquí
// Y para eso, se crea un interfaz


// Aquí el resto de propiedades, como la cantidad de vinos que tiene cada tipo
// Las pasamos a readonly para que cree el getter pero NO el setter
// Debemos personalizar el getter porque siempre mostraría 0
@property (readonly, nonatomic) NSUInteger redWineCount;
@property (readonly, nonatomic) NSUInteger whiteWineCount;
@property (readonly, nonatomic) NSUInteger otherWineCount;

// Métodos para buscar los vinos
// Importando primero el modelo de vino
-(CCPWineModel *) redWineAtIndex: (NSUInteger) index;
-(CCPWineModel *) whiteWineAtIndex: (NSUInteger) index;
-(CCPWineModel *) otherWineAtIndex: (NSUInteger) index;

@end
