import * as React from 'react';
import MapView, {Marker} from 'react-native-maps';
import {StyleSheet, Text, View, Dimensions, StatusBar, TouchableOpacity, Image} from 'react-native';
import * as Location from 'expo-location';
import {mapStyle} from "./assets/map-style.json";
import {useEffect, useRef} from "react";
import CurrentLocationButton from "./components/CurrentLocationButton";
// import { initializeApp } from "firebase/app";

// const firebaseConfig = {
//     apiKey: "AIzaSyCTinB9uZa3foLvQXP5UtNHZks4kLUYOLk",
//     authDomain: "ecochat-mobile.firebaseapp.com",
//     projectId: "ecochat-mobile",
//     storageBucket: "ecochat-mobile.appspot.com",
//     messagingSenderId: "700388965972",
//     appId: "1:700388965972:web:b3254ed195802890fe77c1",
//     measurementId: "G-RN8BTSN05N"
// };
//
// const app = initializeApp(firebaseConfig);




export default function App() {
    const mapView = useRef<MapView>();
    StatusBar.setHidden(true)

    useEffect(() => {
        (async () => {
            await Location.requestForegroundPermissionsAsync();
        })();
    }, []);

    const handleCurrentLocationButtonPress = async () => {
        const location = await Location.getCurrentPositionAsync();

        mapView.current?.animateCamera({
            center: {
                latitude: location.coords.latitude,
                longitude: location.coords.longitude
            },
            zoom: 18
        }, {duration: 1000});
    }

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

            <View style={styles.header}>
                <Text>
                    <Text style={styles.headerText}>ECO</Text><Text style={styles.headerTextBold}>CHAT</Text>
                </Text>
            </View>

            <CurrentLocationButton mapView={mapView.current!} />
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
    },
    header: {
        elevation: 24,
        position: "absolute",
        width: Dimensions.get('screen').width,
        height: 60,
        backgroundColor: "#33835c",
        flex:1,
        justifyContent: "center",
        alignItems: "center",
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 12,
        },
        shadowOpacity: 0.58,
        shadowRadius: 16.00,
    },
    headerText: {
        color: "white",
        fontSize: 18,
    },
    headerTextBold: {
        color: "white",
        fontSize: 18,
        fontWeight: "bold",
    }
});