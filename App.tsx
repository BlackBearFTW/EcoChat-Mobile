import * as React from 'react';
import MapView, {LatLng, Marker, PROVIDER_GOOGLE, Region} from 'react-native-maps';
import {StyleSheet, Text, View, Dimensions, StatusBar, TouchableOpacity, Image, Alert} from 'react-native';
import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useRef, useState} from "react";
import CurrentLocationButton from "./components/CurrentLocationButton";
import Header from "./components/Header";
import { collection, getDocs, collectionGroup} from "firebase/firestore";
import * as Linking from 'expo-linking';
import db from "./firestore";

export default function App() {
    const mapView = useRef<MapView>();
    const [mapReady, setMapReady] = useState(false);
    const [showMarkers, setMarkerVisibility] = useState(true);
    const [markers, setMarkers] = useState<LatLng[]>([]);
    StatusBar.setHidden(false)
    StatusBar.setBackgroundColor("#389162")

    useEffect(() => {
        (async () => {

            const {status} = await Location.requestForegroundPermissionsAsync();

            if (status !== 'granted') {
                // TODO: Deal with users who denied location permission
                return;
            }

            const location = await Location.getCurrentPositionAsync();

            mapView.current!.animateCamera({
                center: {
                    latitude: location.coords.latitude,
                    longitude: location.coords.longitude,
                },
                zoom: 18
            }, {duration: 1000});

            const querySnapshot = await getDocs(collectionGroup(db, "markers"));
            const data: LatLng[] = [];

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

    const getRouteUrl = async (coords: LatLng) => {
        const location = await Location.getCurrentPositionAsync();

        return `https://www.google.com/maps/dir/${location.coords.latitude},${location.coords.longitude}/${coords.latitude},${coords.longitude}`
    }

    return (
        <>
            <MapView
                style={styles.map}
                provider={PROVIDER_GOOGLE}
                customMapStyle={mapStyle}
                showsUserLocation={true}
                toolbarEnabled={false}
                ref={(current) => mapView.current = current!}
                minZoomLevel={11}
                maxZoomLevel={18}
                showsCompass={false}
                showsMyLocationButton={false}
                onMapReady={() => setMapReady(true)}
                onRegionChange={region => {
                    (region.longitudeDelta >= 0.079 && region.latitudeDelta >= 0.079) ?
                        setMarkerVisibility(false) :
                        setMarkerVisibility(true)
                }}
                initialRegion={{
                    latitude: 51.4392648,
                    longitude: 5.478633,
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                }}>
                {showMarkers && markers?.map(marker => (
                    <Marker
                        key={marker.longitude + marker.latitude}
                        coordinate={{
                            latitude: marker.latitude,
                            longitude: marker.longitude
                        }}
                        onPress={event => {
                            getRouteUrl(event.nativeEvent.coordinate)
                                .then(url => Linking.openURL(url));
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