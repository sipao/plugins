// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class GroundOverlaysController {
  private final Map<String, GroundOverlayController> groundOverlayIdToController;
  private final Map<String, String> googleMapsGroundOverlayIdToDartGroundOverlayId;
  private final MethodChannel methodChannel;
  private final Registrar registrar;
  private GoogleMap googleMap;

  GroundOverlaysController(MethodChannel methodChannel, Registrar registrar) {
    this.groundOverlayIdToController = new HashMap<>();
    this.googleMapsGroundOverlayIdToDartGroundOverlayId = new HashMap<>();
    this.methodChannel = methodChannel;
    this.registrar = registrar;
  }

  void setGoogleMap(GoogleMap googleMap) {
    this.googleMap = googleMap;
  }

  void addGroundOverlays(List<Object> groundOverlaysToAdd) {
    if (groundOverlaysToAdd != null) {
      for (Object groundOverlayToAdd : groundOverlaysToAdd) {
        addGroundOverlay(groundOverlayToAdd);
      }
    }
  }

  void changeGroundOverlays(List<Object> groundOverlaysToChange) {
    if (groundOverlaysToChange != null) {
      for (Object groundOverlayToChange : groundOverlaysToChange) {
        changeGroundOverlay(groundOverlayToChange);
      }
    }
  }

  void removeGroundOverlays(List<Object> groundOverlayIdsToRemove) {
    if (groundOverlayIdsToRemove == null) {
      return;
    }
    for (Object rawGroundOverlayId : groundOverlayIdsToRemove) {
      if (rawGroundOverlayId == null) {
        continue;
      }
      String groundOverlayId = (String) rawGroundOverlayId;
      final GroundOverlayController groundOverlayController = groundOverlayIdToController.remove(groundOverlayId);
      if (groundOverlayController != null) {
        groundOverlayController.remove();
        googleMapsGroundOverlayIdToDartGroundOverlayId.remove(groundOverlayController.getGoogleMapsGroundOverlayId());
      }
    }
  }

  private void addGroundOverlay(Object groundOverlay) {
    if (groundOverlay == null) {
      return;
    }
    GroundOverlayBuilder groundOverlayBuilder = new GroundOverlayBuilder(this.registrar);
    String groundOverlayId = Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayBuilder);
    GroundOverlayOptions options = groundOverlayBuilder.build();
    addGroundOverlay(groundOverlayId, options);
  }

  private void addGroundOverlay(String groundOverlayId, GroundOverlayOptions groundOverlayOptions) {
    final GroundOverlay groundOverlay = googleMap.addGroundOverlay(groundOverlayOptions);
    GroundOverlayController controller = new GroundOverlayController(groundOverlay, this.registrar);
    groundOverlayIdToController.put(groundOverlayId, controller);
    googleMapsGroundOverlayIdToDartGroundOverlayId.put(groundOverlay.getId(), groundOverlayId);
  }

  private void changeGroundOverlay(Object groundOverlay) {
    if (groundOverlay == null) {
      return;
    }
    String groundOverlayId = getGroundOverlayId(groundOverlay);
    GroundOverlayController groundOverlayController = groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController != null) {
      Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getGroundOverlayId(Object groundOverlay) {
    Map<String, Object> groundOverlayMap = (Map<String, Object>) groundOverlay;
    return (String) groundOverlayMap.get("groundOverlayId");
  }
}
