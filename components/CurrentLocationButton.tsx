import MapView from "react-native-maps";
import {Image, TouchableOpacity} from "react-native";
import * as Location from "expo-location";
import * as React from "react";

export function CurrentLocationButton({mapView}: {mapView: MapView}) {

    const handlePress = async () => {
        const camera = await await mapView.getCamera()!;
        const location = await Location.getCurrentPositionAsync();

        mapView.animateCamera({
            center: {
                latitude: location.coords.latitude,
                longitude: location.coords.longitude
            }
        }, {duration: 1000});
    }


    return (
        <TouchableOpacity
            style={styles.myLocation}
            onPress={handlePress}
        >
        <Image source={require("./assets/user-location.png")} style={styles.myLocationIcon} />
    </TouchableOpacity>
    )
}