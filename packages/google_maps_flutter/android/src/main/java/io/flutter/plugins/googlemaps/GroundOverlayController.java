// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import android.content.res.AssetManager;
import android.content.res.AssetFileDescriptor;
import android.graphics.BitmapFactory;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.io.IOException;

/** Controller of a single GroundOverlay on the map. */
class GroundOverlayController implements GroundOverlayOptionsSink {
  private final GroundOverlay groundOverlay;
  private final String googleMapsGroundOverlayId;
  private final Registrar registrar;

  GroundOverlayController(GroundOverlay groundOverlay, Registrar registrar) {
    this.groundOverlay = groundOverlay;
    this.googleMapsGroundOverlayId = groundOverlay.getId();
    this.registrar = registrar;
  }

  void remove() {
    groundOverlay.remove();
  }

  @Override
  public void setBounds(LatLng southWest, LatLng northEast) {
    LatLngBounds bounds = LatLngBounds.builder()
            .include(southWest)
            .include(northEast)
            .build();

    groundOverlay.setPositionFromBounds(bounds);
  }

  @Override
  public void setAssetImageName(String assetImageName) {
    try {
      AssetManager assetManager = this.registrar.context().getAssets();
      String key = this.registrar.lookupKeyForAsset(assetImageName);
      System.out.println("kakakakakakakakakakakakakaka111");
      System.out.println(key);
      AssetFileDescriptor fd = assetManager.openFd(key);
      System.out.println("kakakakakakakakakakakakakaka2222");

      BitmapDescriptor bitmapDescriptor
              = BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(fd.createInputStream()));

      System.out.println("kakakakakakakakakakakakakaka3333");
      groundOverlay.setImage(bitmapDescriptor);
      System.out.println("kakakakakakakakakakakakakaka4444");
    } catch (IOException exception) {
      System.out.println("IOExceptionIOExceptionIOExceptionIOExceptionIOExceptionIOException111");
      System.out.println(exception.getMessage());
      System.out.println("IOExceptionIOExceptionIOExceptionIOExceptionIOExceptionIOException222");
    }
  }

  String getGoogleMapsGroundOverlayId() {
    return googleMapsGroundOverlayId;
  }
}
