import * as React from 'react';
import MapView, {LatLng, Marker, PROVIDER_GOOGLE} from 'react-native-maps';
import {StyleSheet, Dimensions, StatusBar, Linking} from 'react-native';
import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useRef, useState} from "react";
import CurrentLocationButton from "./components/CurrentLocationButton";
import Header from "./components/Header";
import { getDocs, collection} from "firebase/firestore";
import db from "./firestore";
import MarkerPopup from "./components/MarkerPopup";

export default function App() {
    const mapView = useRef<MapView>();
    const [mapReady, setMapReady] = useState(false);
    const [markersData, setMarkersData] = useState<PartialMarkerInterface[]>([]);
    const [activeMarker, setActiveMarker] = useState<PartialMarkerInterface | null>(null);

    useEffect(() => {
        (async () => {
            StatusBar.setHidden(false)
            StatusBar.setBackgroundColor("#389162")
            const {status} = await Location.requestForegroundPermissionsAsync();

            // TODO: Deal with users who denied location permission
            if (status !== 'granted') return;

            const location = await Location.getCurrentPositionAsync();

            mapView.current!.animateCamera({
                center: {
                    latitude: location.coords.latitude,
                    longitude: location.coords.longitude,
                },
                zoom: 18
            }, {duration: 1000});

            const querySnapshot = await getDocs(collection(db, "markers"));
            const data: PartialMarkerInterface[] = [];

            querySnapshot.forEach((doc) => {
                const documentData = doc.data()
                data.push({
                    documentId: doc.id,
                    location: {
                        latitude: documentData["location"].latitude,
                        longitude: documentData["location"].longitude
                    }
                });
            });

            setMarkersData(data);
        })();
    }, []);

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
                onPress={() => setActiveMarker(null)}
                initialRegion={{
                    latitude: 51.4392648,
                    longitude: 5.478633,
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                }}>
                {markersData?.map((marker, index) => (
                    <Marker
                        key={index}
                        coordinate={{
                            latitude: marker.location.latitude,
                            longitude: marker.location.longitude
                        }}
                        onPress={event => {
                            setActiveMarker(marker);
                        }}
                        image={require("./assets/marker-icon.png")}
                        pinColor={"green"}
                    />
                ))}
            </MapView>

            <Header />

            {mapReady && <CurrentLocationButton mapView={mapView.current!} popupOpen={(activeMarker !== null)} />}
            {activeMarker && <MarkerPopup markerDocumentId={activeMarker.documentId} />}
        </>
    );
}

const styles = StyleSheet.create({
    map: {
        width: Dimensions.get('screen').width,
        height: Dimensions.get('screen').height,
        elevation: 1,
        zIndex: 3
    }
});