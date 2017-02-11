//
//  CCPWebViewController.m
//  Baccus
//
//  Created by Carlos on 23/12/16.
//  Copyright © 2016 Carlos. All rights reserved.
//

#import "CCPWebViewController.h"
#import "CCPWineryTableViewController.h"

@implementation CCPWebViewController


-(id) initWithModel: (CCPWineModel *) aModel{
    if (self = [super initWithNibName: nil
                               bundle: nil]){
        _model = aModel;
        
        // Propiedad heredada
        // Mejor usar el setter
        self.title = @"Web";
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Nos inventamos el método displayURL que definiremos abajo
    // Cambiamos el método displayURL por el método syncViewToModel
    //[self displayURL: self.model.wineCompanyWeb];
    
    // Alta en la notificación
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver: self // suscriptor: apúntame a mi
               selector: @selector(wineDidChange:)  // Tenemos un mensaje a un objeto y no mandamos el nombre
                                                    // mandamos el número que identifica al mensaje
                                                    // así obtenemos el número del mensaje desde el nombre
                                                    // con @selector()
                   name: NEW_WINE_NOTIFICATION_NAME // nombre de la notificación
                 object: nil];                      // Objeto que envía la notificación
                                                    // Con nil nos da igual
    // O sea, cuando alguien (nil) mande el mensaje (NEW_WINE_NOTIFICATION_NAME)
    // me mandas un mensaje (wineDidChange) que me saco de la manga
    // OJO: hay que implementar ese mensaje de vuelta, o la aplicación se caerá

    [self syncViewToModel];
    
}

-(void) wineDidChange: (NSNotification *) notification{
    
    NSDictionary *dict = [notification userInfo];
    CCPWineModel *newWine = [dict objectForKey:WINE_KEY];
    
    //Actualizar el modelo
    self.model = newWine;
    
    //Aquí lo mismo, cambiamos displayURL por syncViewToModel
    //[self displayURL: self.model.wineCompanyWeb];
    [self syncViewToModel];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Baja en la notificación (de todas en este caso)
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
// Aquí se puede ver la documentación para saber qué hace el delegado

//Aquí iniciamos el activityView
- (void) webViewDidStartLoad:(UIWebView *)webView{
    // Desde aquí controlaremos la barra de progreso para iniciarla
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

// En este caso basta con mandar un mensaje cuando termina de cargar la URL
// Buscamos el método tras finalizar la carga
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    // Desde aquí paramos la barra de progreso
    // OJO: Inicialmente los mensajes se mandan a nil y parece que no funciona
    // Hemos preparado el WebViewController para ser delegado de WebView,
    // pero no hemos dicho a la WebView quién es su delegado
    [self.activityView stopAnimating];
    [self.activityView setHidden: YES];
    
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error{
    // Desde aquí controlaremos la barra de progreso para detenerla
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;

    //La alerta la omito porque el código está obsoleto
    NSLog(@"Error webView: %@", error.localizedDescription);
    
}

#pragma mark - Utils
// Aquí definimos el método que nos hemos inventado
// Para enviarle el mensaje de carga de la URL
-(void) displayURL: (NSURL *) aURL{

    // Aquí le decimos al objeto quién es el delegado
    // Así los mensajes ya funcionarán y dentendrá la barra de progreso
    self.browser.delegate = self;

    // Desde aquí controlaremos la barra de progreso para iniciarla
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    // Continuamos cargando la vista
    [self.browser loadRequest:[NSURLRequest requestWithURL:aURL]];
}

-(void) syncViewToModel{
    
    // Antes teníamos displayURL
    // Ahora tenemos este método que no pasa la URL como parámetro
    
    //Aquí le decimos al objeto quién es el delegado
    // Así los mensajes ya funcionarán y dentendrá la barra de progreso
    self.browser.delegate = self;
    
    // Cambiamos el título
    self.title = self.model.wineCompanyName;

    // Desde aquí controlaremos la barra de progreso para iniciarla
    // Esta parte la omito para pasarla al delegado
    //self.activityView.hidden = NO;
    //[self.activityView startAnimating];
    
    // Continuamos cargando la vista
    [self.browser loadRequest:[NSURLRequest requestWithURL:self.model.wineCompanyWeb]];
}

@end
