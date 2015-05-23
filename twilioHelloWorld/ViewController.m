//
//  ViewController.m
//  twilioHelloWorld
//
//  Created by Patrick Wilson on 5/21/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "ViewController.h"
#import <WhirlyGlobeMaplyComponent/WhirlyGlobeComponent.h>
#import "userObject.h"

@interface ViewController ()
- (void) addCountries;


@end

@implementation ViewController{
    WhirlyGlobeViewController *theViewC;
    NSDictionary *vectorDict;
    UILabel *quoteLabel;
    UILabel *quoteLabel2;
    UIImageView *imageView;
    UIImageView *profilePic;
    UILabel *profileName;
    UIButton *yesButton;
    UIButton *noButton;
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor grayColor]];
    theViewC = [[WhirlyGlobeViewController alloc] init];
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 600);
    [self addChildViewController:theViewC];
    
    quoteLabel = [UILabel new];
    [quoteLabel setText:@"Spin the Globe"];
    [quoteLabel setFrame:CGRectMake(0, 30, self.view.frame.size.width, 100)];
    [quoteLabel setTextAlignment:NSTextAlignmentCenter];
    [quoteLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [quoteLabel setMinimumScaleFactor:.2f];
    quoteLabel.adjustsFontSizeToFitWidth = YES;
    [quoteLabel setTextColor:[UIColor whiteColor]];
    quoteLabel.numberOfLines = 0;
    [self.view addSubview:quoteLabel];
    
    quoteLabel2 = [UILabel new];
    [quoteLabel2 setText:@"Click a Pin to Chat"];
    [quoteLabel2 setFrame:CGRectMake(0, 470, self.view.frame.size.width, 100)];
    [quoteLabel2 setTextAlignment:NSTextAlignmentCenter];
    [quoteLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [quoteLabel2 setMinimumScaleFactor:.2f];
    quoteLabel2.adjustsFontSizeToFitWidth = YES;
    [quoteLabel2 setTextColor:[UIColor whiteColor]];
    quoteLabel2.numberOfLines = 0;
    [self.view addSubview:quoteLabel2];
    
    imageView = [UIImageView new];
    [imageView setFrame:CGRectMake(0, 0, 366/8, 592/8)];
    [imageView setCenter:self.view.center];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"pin.png"]];
    //[self.view addSubview:imageView];
    imageView.clipsToBounds = YES;
    
    profilePic = [UIImageView new];
    [profilePic setFrame:CGRectMake(30, 500, 80, 80)];
    [profilePic setContentMode:UIViewContentModeScaleAspectFit];
    [profilePic setImage:[UIImage imageNamed:@"pic.png"]];
    [self.view addSubview:profilePic];
    profilePic.clipsToBounds = YES;
    
    profileName = [UILabel new];
    [profileName setText:@""];
    [profileName setFrame:CGRectMake(120, 500, self.view.frame.size.width-120, 80)];
    [profileName setTextAlignment:NSTextAlignmentCenter];
    [profileName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [profileName setMinimumScaleFactor:.2f];
    profileName.adjustsFontSizeToFitWidth = YES;
    [profileName setTextColor:[UIColor whiteColor]];
    profileName.numberOfLines = 0;
    [self.view addSubview:profileName];
    
    yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [yesButton addTarget:self
                           action:@selector(yes)
                 forControlEvents:UIControlEventTouchUpInside];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(80, 590, 50, 50);
    [self.view addSubview:yesButton];
    
    noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [noButton addTarget:self
                  action:@selector(no)
        forControlEvents:UIControlEventTouchUpInside];
    [noButton setBackgroundImage:[UIImage imageNamed:@"xmark.png"] forState:UIControlStateNormal];
    noButton.frame = CGRectMake(220, 587, 50, 50);
    [self.view addSubview:noButton];
    
    [profileName setHidden:YES];
    [profilePic setHidden:YES];
    [yesButton setHidden:YES];
    [noButton setHidden:YES];
    
    WhirlyGlobeViewController *globeViewC = nil;
    MaplyViewController *mapViewC = nil;
    if ([theViewC isKindOfClass:[WhirlyGlobeViewController class]])
        globeViewC = (WhirlyGlobeViewController *)theViewC;
    else
        mapViewC = (MaplyViewController *)theViewC;
    
    // we want a black background for a globe, a white background for a map.
    theViewC.clearColor = (globeViewC != nil) ? [UIColor grayColor] : [UIColor whiteColor];
    [theViewC setZoomLimitsMin:10.0 max:10.0];
    
    // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
    theViewC.frameInterval = 2;
    
    // set up the data source
    MaplyMBTileSource *tileSource =
    [[MaplyMBTileSource alloc] initWithMBTiles:@"geography-class_medres"];
    
    // set up the layer
    MaplyQuadImageTilesLayer *layer =
    [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys
                                               tileSource:tileSource];
    
    if (true){
        NSString *baseCacheDir =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
         objectAtIndex:0];
        NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/osmtiles/",
                                         baseCacheDir];
        int maxZoom = 18;
        
        // MapQuest Open Aerial Tiles, Courtesy Of Mapquest
        // Portions Courtesy NASA/JPL­Caltech and U.S. Depart. of Agriculture, Farm Service Agency
        MaplyRemoteTileSource *tileSource =
        [[MaplyRemoteTileSource alloc]
         initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/"
         ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = aerialTilesCacheDir;
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    }
    layer.handleEdges = (globeViewC != nil);
    layer.coverPoles = (globeViewC != nil);
    layer.requireElev = false;
    layer.waitLoad = false;
    layer.drawPriority = 0;
    layer.singleLevelLoading = false;
    [theViewC addLayer:layer];
    //[theViewC setKeepNorthUp:YES];
    if (globeViewC != nil)
        globeViewC.delegate = self;
    
    // start up over San Francisco, center of the universe
    if (globeViewC != nil)
    {
        globeViewC.height = 1.1;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                                 time:1.0];
    } else {
        mapViewC.height = 1.0;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                               time:1.0];
    }
    
    vectorDict = @{
                   kMaplyColor: [UIColor whiteColor],
                   kMaplySelectable: @(true),
                   kMaplyVecWidth: @(4.0)};
    
    // add the countries
    [self addCountries];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCountries
{
    // handle this in another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
                   ^{
                       
                       // get the image and create the markers
                       UIImage *icon = [UIImage imageNamed:@"pin.png"];
        
                        MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
                        marker.image = icon;
                        marker.loc =MaplyCoordinateMakeWithDegrees(-79.516667, 8.983333);
                        marker.size = CGSizeMake(366/16, 592/16);
                       userObject *test = [userObject new];
                       test.name = @"Patrick";
                       test.profilePicture = @"pic.png";
                       marker.userObject = test;
                       
                       [theViewC addScreenMarkers:[NSArray arrayWithObject:marker] desc:nil];
                       
                       
                       
                       NSArray *allOutlines = [[NSBundle mainBundle] pathsForResourcesOfType:@"geojson" inDirectory:nil];
                       
                       for (NSString *outlineFile in allOutlines)
                       {
                           NSData *jsonData = [NSData dataWithContentsOfFile:outlineFile];
                           if (jsonData)
                           {
                               MaplyVectorObject *wgVecObj = [MaplyVectorObject VectorObjectFromGeoJSON:jsonData];
                               // the admin tag from the country outline geojson has the country name ­ save
                               NSString *vecName = [[wgVecObj attributes] objectForKey:@"ADMIN"];
                               wgVecObj.userObject = vecName;
                               
                               
                               // add the outline to our view
//                               MaplyComponentObject *compObj = [theViewC addVectors:[NSArray arrayWithObject:wgVecObj] desc:vectorDict];
//                               // If you ever intend to remove these, keep track of the MaplyComponentObjects above.
//                               if ([vecName length] > 0)
//                               {
//                                   MaplyScreenLabel *label = [[MaplyScreenLabel alloc] init];
//                                   //label.layoutImportance = 10.0;
//                                   label.text = vecName;
//                                   label.loc = [wgVecObj center];
//                                   label.selectable = true;
//                                   [theViewC addScreenLabels:@[label] desc:
//                                    @{
//                                      kMaplyFont: [UIFont boldSystemFontOfSize:24.0],
//                                      kMaplyTextOutlineColor: [UIColor blackColor],
//                                      kMaplyTextOutlineSize: @(1.0),
//                                      kMaplyColor: [UIColor whiteColor]
//                                      }];
//                               }
                           }
                       }
                   });
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC
                    didTapAt:(MaplyCoordinate)coord
{
    NSString *title = @"Tap Location:";
    NSString *subtitle = [NSString stringWithFormat:@"(%.2fN, %.2fE)",
                          coord.y*57.296,coord.x*57.296];
//    [self addAnnotation:title withSubtitle:subtitle at:coord];
}

- (void) handleSelection:(MaplyBaseViewController *)viewC
                selected:(NSObject *)selectedObj
{
    // ensure it's a MaplyVectorObject. It should be one of our outlines.
    if ([selectedObj isKindOfClass:[MaplyVectorObject class]])
    {
        MaplyVectorObject *theVector = (MaplyVectorObject *)selectedObj;
        MaplyCoordinate location;
        
        if ([theVector centroid:&location])
        {
            NSString *title = @"Selected:";
            NSString *subtitle = (NSString *)theVector.userObject;
//            [self addAnnotation:title withSubtitle:subtitle at:location];
        }
    }
}

// This is the version for a globe
- (void) globeViewController:(WhirlyGlobeViewController *)viewC
                   didSelect:(NSObject *)selectedObj
{
//    [self handleSelection:viewC selected:selectedObj];
    if ([selectedObj isKindOfClass:[MaplyScreenMarker class]]){
        MaplyScreenMarker *theVector = (MaplyScreenMarker *)selectedObj;
//        [theVector setImage:[UIImage imageNamed:@"green-pin-hi.png"]];
        
        
        MaplyCoordinate newCenter =  MaplyCoordinateMake(theVector.loc.x-.05, theVector.loc.y-.01);
        [theViewC animateToPosition:newCenter time:.25];
        
        userObject *hey = (userObject*)[theVector userObject];
        profileName.text = [NSString stringWithFormat:@"Video Chat with %@?",hey.name];
        profilePic.image = [UIImage imageNamed:hey.profilePicture];
        
        
        
        
        [UIView transitionWithView:quoteLabel2
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [quoteLabel2 setHidden:YES];
        
        [UIView transitionWithView:quoteLabel
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [quoteLabel setHidden:YES];
        
        [UIView transitionWithView:profileName
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [profileName setHidden:NO];
        
        [UIView transitionWithView:profilePic
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [profilePic setHidden:NO];
        
        [UIView transitionWithView:yesButton
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [yesButton setHidden:NO];
        
        [UIView transitionWithView:noButton
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        [noButton setHidden:NO];
        
    }
}

-(void)yes{
//    [self presentViewController:[UIViewController new] animated:YES completion:^{
//        //
//    }];
}

-(void)no{
    double latitude = rand()%20 +50;
    double longitude = -107  + rand()%10;
    [theViewC animateToPosition:MaplyCoordinateMake(longitude, latitude) time:1.0];
    
    
    [UIView transitionWithView:quoteLabel2
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [quoteLabel2 setHidden:NO];
    
    [UIView transitionWithView:quoteLabel
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [quoteLabel setHidden:NO];
    
    [UIView transitionWithView:profileName
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [profileName setHidden:YES];
    
    [UIView transitionWithView:profilePic
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [profilePic setHidden:YES];
    
    [UIView transitionWithView:yesButton
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [yesButton setHidden:YES];
    
    [UIView transitionWithView:noButton
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [noButton setHidden:YES];
}


@end
