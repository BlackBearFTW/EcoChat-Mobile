import * as React from 'react';
import MapView, {Marker} from 'react-native-maps';
import { StyleSheet, Text, View, Dimensions, StatusBar } from 'react-native';

import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect} from "react";

export default function App() {

    useEffect(() => {
        (async () => {
            await Location.requestForegroundPermissionsAsync();
        })();
    }, []);


  return (
        <MapView
            style={styles.map}
            customMapStyle={mapStyle}
            showsUserLocation={true}
            minZoomLevel={10}
            showsCompass={false}
            initialRegion={{
              latitude: 51.441643,
              longitude: 5.469722,
              latitudeDelta: 0.0922,
              longitudeDelta: 0.0421,
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
  );
}

const styles = StyleSheet.create({
  map: {
    width: Dimensions.get('screen').width,
    height: Dimensions.get('screen').height,
  },
});