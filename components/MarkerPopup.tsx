import MarkerStructureInterface from "../interfaces/MarkerStructureInterface";
import {Animated, Button, Dimensions, StyleSheet, Text, View} from "react-native";
import * as React from "react";
import {collectionGroup, doc, getDocs, onSnapshot} from "firebase/firestore";
import db from "../firestore"
import {useEffect, useState} from "react";

function MarkerPopup({markerDocumentId}: {markerDocumentId: string}) {
    const [markerData, setMarkerData] = useState<MarkerStructureInterface>();

    useEffect(() => {
        (async () => {
            const collectionsRef = collectionGroup(db, "markers");
            console.log()


        })()
    }, []);



    return (
        <Animated.View style={styles.popup}>
            <View>
                <Text>{markerData?.status.batteryLevel ?? "Loading.."}</Text>
            </View>
            <Button title={"Zie route op google maps"} onPress={() => {
            }}/>
        </Animated.View>
    );
}

const styles = StyleSheet.create({
    popup: {
        width: Dimensions.get('screen').width,
        position: 'absolute',
        bottom: 0,
        height: 160,
        backgroundColor: '#fff',
        elevation: 3,
        borderRadius: 16,
        padding: 15,
        display: "flex",
        flexDirection: "column"
    }
})
export default MarkerPopup;