import MarkerStructureInterface from "../interfaces/MarkerStructureInterface";
import {Button, Dimensions, Image, Linking, StyleSheet, Text, TouchableHighlight, View} from "react-native";
import * as React from "react";
import {collectionGroup, doc, getDocs, onSnapshot} from "firebase/firestore";
import db from "../firestore"
import {useEffect, useState} from "react";
import {LatLng} from "react-native-maps";
import * as Location from "expo-location";
import Icon from 'react-native-vector-icons/Ionicons';
import Animated, {
    useSharedValue,
    withTiming,
    useAnimatedStyle,
} from 'react-native-reanimated';

function MarkerPopup({markerDocumentId}: {markerDocumentId: string}) {
    const [markerData, setMarkerData] = useState<MarkerStructureInterface | null>(null);
    const bottomValue = useSharedValue(-200);

    const animationStyle = useAnimatedStyle(() => ({bottom: bottomValue.value}))

    // Used to animate the popup
    useEffect(() => {
        bottomValue.value = withTiming(0, {duration: 150})
    }, []);


    // Updates the data inside the popup live when the database data changes.
    useEffect(() => {
        onSnapshot(doc(db, "markers", markerDocumentId), (doc) => {
            setMarkerData(doc.data() as MarkerStructureInterface)
        });

    }, [markerDocumentId]);

    // Generate url for google maps
    const getRouteUrl = async (coords: LatLng) => {
        const location = await Location.getCurrentPositionAsync();
        return `https://www.google.com/maps/dir/${location.coords.latitude},${location.coords.longitude}/${coords.latitude},${coords.longitude}`
    }

    return (
        <Animated.View style={[styles.container, animationStyle]}>
            <View style={styles.sensorParentContainer}>
                <View style={styles.sensorContainer}>
                    <Text style={styles.sensorText}>{`${markerData?.sensorStatus.batteryLevel ?? "..."}%`}</Text>
                    <Text style={{...styles.sensorText, fontWeight: "bold"}}>Accu Batterij</Text>
                </View>
                <View style={styles.sensorContainer}>
                    <Text style={styles.sensorText}>{`${markerData?.sensorStatus.usbSlots.available ?? "..."}/${markerData?.sensorStatus.usbSlots.total ?? "..."}`}</Text>
                    <Text style={{...styles.sensorText, fontWeight: "bold"}}>Beschikbare USB</Text>
                </View>
                { markerData?.roofed &&
                <View style={styles.sensorContainer}>
                    {markerData?.roofed && <Icon name={"home-outline"} size={20} style={{marginBottom: -1}}/>}
                    <Text style={{...styles.sensorText, fontWeight: "bold"}}>Overdekt</Text>
                </View>
                }
            </View>
            <TouchableHighlight
                style={styles.button}
                onPress={() => getRouteUrl(markerData?.location as LatLng).then(url => Linking.openURL(url))}
            >
                <Text style={styles.buttonText}>Bekijk Route <Icon name={"open-outline"} size={16}/></Text>
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
        zIndex: 3,
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
        padding: 18,
        fontWeight: "bold",
        fontSize: 15
    },
    sensorParentContainer: {
        display: "flex",
        flexDirection: "row",
        justifyContent: "space-evenly",
        flexGrow: 1,
        marginBottom: 35
    },
    sensorContainer: {
        display: "flex",
        alignItems: "center",
        justifyContent: "flex-end",
    },
    sensorText: {
        fontSize: 15
    }
})

export default MarkerPopup;