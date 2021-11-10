import MarkerStructureInterface from "../interfaces/MarkerStructureInterface";
import {Animated, Button, Dimensions, Image, Linking, StyleSheet, Text, TouchableHighlight, View} from "react-native";
import * as React from "react";
import {collectionGroup, doc, getDocs, onSnapshot} from "firebase/firestore";
import db from "../firestore"
import {useEffect, useState} from "react";
import {LatLng} from "react-native-maps";
import * as Location from "expo-location";

function MarkerPopup({markerDocumentId}: {markerDocumentId: string}) {
    const [markerData, setMarkerData] = useState<MarkerStructureInterface | null>(null);

    useEffect(() => {

        onSnapshot(doc(db, "markers", markerDocumentId), (doc) => {
            setMarkerData(doc.data() as MarkerStructureInterface)
        });

    }, []);

    const getRouteUrl = async (coords: LatLng) => {
        const location = await Location.getCurrentPositionAsync();
        return `https://www.google.com/maps/dir/${location.coords.latitude},${location.coords.longitude}/${coords.latitude},${coords.longitude}`
    }

    return (
        <Animated.View style={styles.container}>
            <View style={styles.sensorParentContainer}>
                <View style={styles.sensorContainer}>
                    <Text style={styles.sensorText}>{`${markerData?.sensorStatus.batteryLevel ?? "..."}%`}</Text>
                    <Text style={{...styles.sensorText, fontWeight: "bold"}}>Accu Batterij</Text>
                </View>
                <View style={styles.sensorContainer}>
                    <Text style={styles.sensorText}>{`${markerData?.sensorStatus.usbSlots.available ?? "..."}/${markerData?.sensorStatus.usbSlots.total ?? "..."}`}</Text>
                    <Text style={{...styles.sensorText, fontWeight: "bold"}}>Beschikbare USB</Text>
                </View>
            </View>
            <TouchableHighlight
                style={styles.button}
                onPress={() => getRouteUrl(markerData?.location as LatLng).then(url => Linking.openURL(url))}
            >
                <Text style={styles.buttonText}>Bekijk Route</Text>
            </TouchableHighlight>
        </Animated.View>
    );
}

const styles = StyleSheet.create({
    container: {
        width: Dimensions.get('screen').width,
        position: 'absolute',
        bottom: 0,
        height: 200,
        backgroundColor: '#fff',
        elevation: 3,
        borderRadius: 16,
        padding: 15,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between"
    },
    button: {
        display: "flex",
        backgroundColor: "#33835c",
        justifyContent: "center",
        alignItems: "center",
        borderRadius: 8,
    },
    buttonText: {
        color: "white",
        padding: 15,
        fontWeight: "bold"
    },
    sensorParentContainer: {
        display: "flex",
        flexDirection: "row",
        justifyContent: "space-evenly",
        flexGrow: 1
    },
    sensorContainer: {
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
    },
    sensorText: {
        fontSize: 16
    }
})
export default MarkerPopup;