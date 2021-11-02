import * as React from 'react';
import MapView, {Marker} from 'react-native-maps';
import { StyleSheet, Text, View, Dimensions, StatusBar } from 'react-native';
import {mapStyle} from "./assets/map-style.json";

export default function App() {


  return (
        <MapView
            style={styles.map}
            customMapStyle={mapStyle}
            showsUserLocation={true}
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
              latitude: 51.450851,
              longitude: 5.480200
            }}
            image={require("./assets/marker-icon.png")}
            pinColor={"navy"}
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