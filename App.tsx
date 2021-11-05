import * as React from 'react';
import MapView, {Marker} from 'react-native-maps';
import {StyleSheet, Text, View, Dimensions, StatusBar, TouchableOpacity, Image} from 'react-native';
import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useRef, useState} from "react";
import CurrentLocationButton from "./components/CurrentLocationButton";
import Header from "./components/Header";
import { collection, getDocs} from "firebase/firestore";
import db from "./firestore";

interface MarkerData {
    latitude: number,
    longitude: number
}

export default function App() {
    const mapView = useRef<MapView>();
    const [mapReady, setMapReady] = useState(false);
    const [markers, setMarkers] = useState<MarkerData[]>([]);
    StatusBar.setHidden(true)

    useEffect(() => {
        (async () => {

            await Location.requestForegroundPermissionsAsync();

            const querySnapshot = await getDocs(collection(db, "markers"));
            const data: MarkerData[] = [];


            querySnapshot.forEach((doc) => {
                const result = doc.data();

                data.push({
                    latitude: result["geodata"].latitude,
                    longitude: result["geodata"].longitude
                })
            });

            setMarkers(data);
        })();
    }, []);

    console.log(markers);

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
                onMapReady={() => setMapReady(true)}
                initialRegion={{
                    latitude: 51.4392648,
                    longitude: 5.478633,
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                }}>
                {markers?.map(marker => (
                    <Marker
                        key={marker.longitude + marker.latitude}
                        coordinate={{
                            latitude: marker.latitude,
                            longitude: marker.longitude
                        }}
                        image={require("./assets/marker-icon.png")}
                        pinColor={"green"}
                    />
                ))}
            </MapView>

            <Header />

            {mapReady && <CurrentLocationButton mapView={mapView.current!} />}
        </>
    );
}

const styles = StyleSheet.create({
    map: {
        width: Dimensions.get('screen').width,
        height: Dimensions.get('screen').height,
        elevation: 1
    }
});