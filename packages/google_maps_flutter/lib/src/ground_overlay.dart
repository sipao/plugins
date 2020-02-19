// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of google_maps_flutter;

/// Uniquely identifies a [GroundOverlay] among [GoogleMap] groundOverlays.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class GroundOverlayId {
  /// Creates an immutable identifier for a [GroundOverlay].
  GroundOverlayId(this.value) : assert(value != null);

  /// value of the [GroundOverlayId].
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlayId typedOther = other;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'GroundOverlayId{value: $value}';
  }
}

/// Draws a groundOverlay on the map.
@immutable
class GroundOverlay {
  /// Creates an immutable representation of a [GroundOverlay] to draw on [GoogleMap].
  const GroundOverlay({
    @required this.groundOverlayId,
    @required this.southWest,
    @required this.northEast,
    @required this.assetImageName,
  });

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;
  /// GroundOverlay's south-west corner.
  final LatLng southWest;
  /// GroundOverlay's north-east corner.
  final LatLng northEast;
  /// Overlay image name in flutter assets image
  final String assetImageName;

  /// Creates a new [GroundOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    LatLng southWestParam,
    LatLng northEastParam,
    String assetImageNameParam,
  }) {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      southWest: southWestParam,
      northEast: northEastParam,
      assetImageName: assetImageNameParam
    );
  }

  /// Creates a new [GroundOverlay] object whose values are the same as this instance.
  GroundOverlay clone() => copyWith();

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    print("---addIfPresent");
    print(groundOverlayId);
    print(southWest);
    print(northEast);
    print(assetImageName);

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('southWest', southWest != null ? southWest._toJson() : null);
    addIfPresent('northEast', northEast != null ? northEast._toJson() : null);
    addIfPresent('assetImageName', assetImageName);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlay typedOther = other;
    return groundOverlayId == typedOther.groundOverlayId &&
        southWest == typedOther.southWest &&
        northEast == typedOther.northEast &&
        assetImageName == typedOther.assetImageName;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;
}

Map<GroundOverlayId, GroundOverlay> _keyByGroundOverlayId(Iterable<GroundOverlay> groundOverlays) {
  if (groundOverlays == null) {
    return <GroundOverlayId, GroundOverlay>{};
  }
  return Map<GroundOverlayId, GroundOverlay>.fromEntries(groundOverlays.map((GroundOverlay groundOverlay) =>
      MapEntry<GroundOverlayId, GroundOverlay>(groundOverlay.groundOverlayId, groundOverlay.clone())));
}

List<Map<String, dynamic>> _serializeGroundOverlaySet(Set<GroundOverlay> groundOverlays) {
  if (groundOverlays == null) {
    return null;
  }
  return groundOverlays.map<Map<String, dynamic>>((GroundOverlay p) => p._toJson()).toList();
}
