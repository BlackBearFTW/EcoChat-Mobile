import * as React from 'react';
import MapView, {Marker, Overlay, Region} from 'react-native-maps';
import {StyleSheet, Text, View, Dimensions, StatusBar, TouchableOpacity, Image, Alert} from 'react-native';

import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useRef} from "react";
import {LocationObject} from "expo-location";

export default function App() {
    const mapView = useRef<MapView>();

    useEffect(() => {
        (async () => {
            StatusBar.setHidden(true)
            await Location.requestForegroundPermissionsAsync();
        })();
    }, []);

    return (
        <>
            <MapView
                style={styles.map}
                customMapStyle={mapStyle}
                showsUserLocation={true}
                toolbarEnabled={false}
                ref={(current) => mapView.current = current!}
                minZoomLevel={10}
                showsCompass={false}
                showsMyLocationButton={false}
                initialRegion={{
                    latitude: 51.4392648,
                    longitude: 5.478633,
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
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
        elevation: 1
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
        elevation: 999,
    },
    myLocationIcon: {
        width: 30,
        height: 30
    }
});