// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GoogleMapGroundOverlayController.h"
#import "JsonConversions.h"

@implementation FLTGoogleMapGroundOverlayController {
  GMSGroundOverlay* _groundOverlay;
  GMSMapView* _mapView;
  NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initGroundOverlayWithSouthWest:(CLLocationCoordinate2D)southWest
                                     northEast:(CLLocationCoordinate2D)northEast
                                assetImageName:(NSString *)assetImageName
                               groundOverlayId:(NSString *)groundOverlayId
                                     registrar:(NSObject<FlutterPluginRegistrar>*)registrar
                                       mapView:(GMSMapView*)mapView {
  self = [super init];
  if (self) {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate: southWest coordinate: northEast];

    NSString* key = [registrar lookupKeyForAsset: assetImageName];
    NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
    UIImage *iconImage = [[UIImage alloc]initWithContentsOfFile: path];

    _groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:bounds icon:iconImage];
    _mapView = mapView;
    _groundOverlay.map = mapView;
    _groundOverlayId = groundOverlayId;
    _groundOverlay.userData = @[ groundOverlayId ];
    _registrar = registrar;
    NSLog(@"hogehogehogehoge");
    NSLog(@"bounds: %@", bounds);
    NSLog(@"assetImageName: %@", assetImageName);
    NSLog(@"key: %@", key);
    NSLog(@"path: %@", path);
  }
  return self;
}

- (void)removeGroundOverlay {
  _groundOverlay.map = nil;
}

#pragma mark - FLTGoogleMapGroundOverlayOptionsSink methods

- (void)setBoundsWithSouthWest:(CLLocationCoordinate2D)southWest northEast:(CLLocationCoordinate2D)northEast {
  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate: southWest coordinate: northEast];
  _groundOverlay.bounds = bounds;
}

- (void)setAssetImageName:(NSString *)assetImageName {
    NSString* key = [_registrar lookupKeyForAsset: assetImageName];
    NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
    UIImage *iconImage = [[UIImage alloc]initWithContentsOfFile: path];

  _groundOverlay.icon = iconImage;
}

@end

static int ToInt(NSNumber* data) { return [FLTGoogleMapJsonConversions toInt:data]; }

static BOOL ToBool(NSNumber* data) { return [FLTGoogleMapJsonConversions toBool:data]; }

static CLLocationCoordinate2D ToLocation(NSArray* data) {
  return [FLTGoogleMapJsonConversions toLocation:data];
}

static CLLocationDistance ToDistance(NSNumber* data) {
  return [FLTGoogleMapJsonConversions toFloat:data];
}

static UIColor* ToColor(NSNumber* data) { return [FLTGoogleMapJsonConversions toColor:data]; }

static void InterpretGroundOverlayOptions(NSDictionary* data, id<FLTGoogleMapGroundOverlayOptionsSink> sink,
                                   NSObject<FlutterPluginRegistrar>* registrar) {
  NSArray* southWest = data[@"southWest"];
  NSArray* northEast = data[@"northEast"];

  if (southWest && northEast) {
  NSLog(@"bbbbbbbbbbbbbbb");
    [sink setBoundsWithSouthWest:ToLocation(southWest) northEast: ToLocation(northEast)];
  }

  NSString* assetImageName = data[@"assetImageName"];
  if (assetImageName != nil) {
  NSLog(@"ccccccccccc");
    [sink setAssetImageName: assetImageName];
  }
  NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  NSLog(@"%@", southWest);
  NSLog(@"%@", northEast);
  NSLog(@"%@", assetImageName);
}

@implementation FLTGroundOverlaysController {
  NSMutableDictionary* _groundOverlayIdToController;
  FlutterMethodChannel* _methodChannel;
  NSObject<FlutterPluginRegistrar>* _registrar;
  GMSMapView* _mapView;
}

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _groundOverlayIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray*)groundOverlaysToAdd {
  for (NSDictionary* groundOverlay in groundOverlaysToAdd) {
    CLLocationCoordinate2D southWest = [FLTGroundOverlaysController getSouthWest: groundOverlay];
    CLLocationCoordinate2D northEast = [FLTGroundOverlaysController getNorthEast: groundOverlay];

    NSString* assetImageName = [FLTGroundOverlaysController getAssetImageName: groundOverlay];

    NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId: groundOverlay];

    FLTGoogleMapGroundOverlayController* controller =
        [[FLTGoogleMapGroundOverlayController alloc] initGroundOverlayWithSouthWest: southWest
                                                                          northEast: northEast
                                                                     assetImageName: assetImageName
                                                                    groundOverlayId: groundOverlayId
                                                                          registrar: _registrar
                                                                            mapView:_mapView];

    InterpretGroundOverlayOptions(groundOverlay, controller, _registrar);
    _groundOverlayIdToController[groundOverlayId] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray*)groundOverlaysToChange {
  for (NSDictionary* groundOverlay in groundOverlaysToChange) {
    NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];
    FLTGoogleMapGroundOverlayController* controller = _groundOverlayIdToController[groundOverlayId];
    if (!controller) {
      continue;
    }
    InterpretGroundOverlayOptions(groundOverlay, controller, _registrar);
  }
}

- (void)removeGroundOverlayIds:(NSArray*)groundOverlayIdsToRemove {
  for (NSString* groundOverlayId in groundOverlayIdsToRemove) {
    if (!groundOverlayId) {
      continue;
    }
    FLTGoogleMapGroundOverlayController* controller = _groundOverlayIdToController[groundOverlayId];
    if (!controller) {
      continue;
    }
    [controller removeGroundOverlay];
    [_groundOverlayIdToController removeObjectForKey:groundOverlayId];
  }
}

- (bool)hasGroundOverlayWithId:(NSString*)groundOverlayId {
  if (!groundOverlayId) {
    return false;
  }
  return _groundOverlayIdToController[groundOverlayId] != nil;
}

+ (CLLocationCoordinate2D)getSouthWest:(NSDictionary*)groundOverlay {
  NSArray* southWest = groundOverlay[@"southWest"];
  return ToLocation(southWest);
}

+ (CLLocationCoordinate2D)getNorthEast:(NSDictionary*)groundOverlay {
  NSArray* northEast = groundOverlay[@"northEast"];
  return ToLocation(northEast);
}

+ (NSString*)getAssetImageName:(NSDictionary*)groundOverlay {
  NSString* assetImageName = groundOverlay[@"assetImageName"];
  return assetImageName;
}

+ (NSString*)getGroundOverlayId:(NSDictionary*)groundOverlay {
  return groundOverlay[@"groundOverlayId"];
}
@end
