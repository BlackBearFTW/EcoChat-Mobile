import MapView from "react-native-maps";
import { Image, StyleSheet, TouchableOpacity} from "react-native";
import * as Location from "expo-location";
import * as React from "react";

function CurrentLocationButton({mapView}: {mapView: MapView}) {

    const handlePress = async () => {
        const location = await Location.getCurrentPositionAsync();

        mapView.animateCamera({
            center: {
                latitude: location.coords.latitude,
                longitude: location.coords.longitude,
            },
            zoom: 18
        }, {duration: 1000});
    }

    return (
        <TouchableOpacity
            style={styles.myLocation}
            onPress={handlePress}
        >
        <Image source={require("../assets/user-location.png")} style={styles.myLocationIcon} />
    </TouchableOpacity>
    )
}


const styles = StyleSheet.create({
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

export default CurrentLocationButton;