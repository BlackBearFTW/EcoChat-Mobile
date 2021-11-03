import * as React from 'react';
import MapView, {Marker, Overlay} from 'react-native-maps';
import {StyleSheet, Text, View, Dimensions, StatusBar, TouchableOpacity, Image} from 'react-native';

import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useState} from "react";

export default function App() {
    const [location, setLocation] = useState<any>(null);

    useEffect(() => {
        (async () => {
            StatusBar.setHidden(true)
            await Location.requestForegroundPermissionsAsync();
        })();
    }, []);

  return (
      <>

          <TouchableOpacity
              style={styles.myLocation}
          >
              <Image source={require("./assets/user-location.png")} style={styles.myLocationIcon} />
          </TouchableOpacity>
          <MapView
              style={styles.map}
              customMapStyle={mapStyle}
              showsUserLocation={true}
              toolbarEnabled={false}
              minZoomLevel={10}
              showsCompass={false}
              showsMyLocationButton={false}
              initialRegion={{
                  latitude: 51.441643,
                  longitude: 5.469722,
                  latitudeDelta: 0,
                  longitudeDelta: 0
              }}>
              <Marker
                  key={"1"}
                  coordinate={{
                      latitude: 51.44369794468786,
                      longitude: 5.47874608280784
                  }}
                  image={require("./assets/marker-icon.png")}
                  pinColor={"green"}
              />
          </MapView>
      </>
  );
}

const styles = StyleSheet.create({
  map: {
    width: Dimensions.get('screen').width,
    height: Dimensions.get('screen').height,
      elevation: 3
  },
    myLocation: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 60,
        position: 'absolute',
        bottom: 15,
        right: 15,
        height: 60,
        backgroundColor: '#fff',
        borderRadius: 100,
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 0,
        },
        shadowOpacity: 0.36,
        shadowRadius: 6.68,
        elevation: 11,
    },
    myLocationIcon: {
      width: 30,
        height: 30
    }
});