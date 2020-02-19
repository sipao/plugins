// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLngBounds;
import android.content.res.AssetManager;
import android.content.res.AssetFileDescriptor;
import android.graphics.BitmapFactory;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.io.IOException;

class GroundOverlayBuilder implements GroundOverlayOptionsSink {
  private final GroundOverlayOptions groundOverlayOptions;
  private Registrar registrar;

  GroundOverlayBuilder(Registrar registrar) {
    this.registrar = registrar;
    this.groundOverlayOptions = new GroundOverlayOptions();
  }

  GroundOverlayOptions build() {
    return groundOverlayOptions;
  }

  @Override
  public void setBounds(LatLng southWest, LatLng northEast) {
    LatLngBounds bounds = LatLngBounds.builder()
      .include(southWest)
      .include(northEast)
      .build();

    groundOverlayOptions.positionFromBounds(bounds);
  }

  @Override
  public void setAssetImageName(String assetImageName) {
    try {
      AssetManager assetManager = this.registrar.context().getAssets();
      String key = this.registrar.lookupKeyForAsset(assetImageName);
      System.out.println("kakakakakakakakakakakakakakaAAA");
      System.out.println(key);
      AssetFileDescriptor fd = assetManager.openFd(key);
      System.out.println("kakakakakakakakakakakakakakaBBBB");

      BitmapDescriptor bitmapDescriptor
              = BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(fd.createInputStream()));

      System.out.println("kakakakakakakakakakakakakakaCCCC");
      groundOverlayOptions.image(bitmapDescriptor);
      System.out.println("kakakakakakakakakakakakakakaDDDD");
    } catch (IOException exception) {
      System.out.println("IOExceptionIOExceptionIOExceptionIOExceptionIOExceptionIOException333");
      System.out.println(exception.getMessage());
      System.out.println("IOExceptionIOExceptionIOExceptionIOExceptionIOExceptionIOException444");
    }
  }
}
