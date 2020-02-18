// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

// Defines circle UI options writable from Flutter.
@protocol FLTGoogleMapGroundOverlayOptionsSink

- (void)setBoundsWithSouthWest:(CLLocationCoordinate2D)southWest northEast:(CLLocationCoordinate2D)northEast;
// - (void)setSouthWest:(CLLocationCoordinate2D)southWest;
// - (void)setNorthEast:(CLLocationCoordinate2D)northEast;
- (void)setAssetImageName:(NSString *)assetImageName;
@end

// Defines ground-overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject <FLTGoogleMapGroundOverlayOptionsSink>
@property(atomic, readonly) NSString* groundOverlayId;
- (instancetype)initGroundOverlayWithPosition:(CLLocationCoordinate2D)position
                                radius:(CLLocationDistance)radius
                       groundOverlayId:(NSString*)groundOverlayId
                             registrar:(NSObject<FlutterPluginRegistrar>*)registrar
                               mapView:(GMSMapView*)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addGroundOverlays:(NSArray*)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray*)groundOverlaysToChange;
- (void)removeGroundOverlayIds:(NSArray*)groundOverlayIdsToRemove;
@end
