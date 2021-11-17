import MapView from "react-native-maps";
import { Image, StyleSheet, TouchableOpacity, View} from "react-native";
import * as Location from "expo-location";
import * as React from "react";
import Animated, {
    useSharedValue,
    withTiming,
    useAnimatedStyle,
} from 'react-native-reanimated';
import {useEffect} from "react";

function CurrentLocationButton({mapView, popupOpen}: {mapView: MapView, popupOpen: boolean}) {
    const bottomValue = useSharedValue(15);
    const scaleValue = useSharedValue(1);

    const animationStyle = useAnimatedStyle(() => {
        return {
            bottom: bottomValue.value,
            transform: [{
                scale: scaleValue.value
            }]
        }
    })

    // Used to animate my location button when popup opens or closes
    useEffect(() => {
        bottomValue.value = withTiming(popupOpen ? 215 : 15, {duration: 150})
        scaleValue.value = withTiming(popupOpen ? 0.8 : 1)
    }, [popupOpen]);


    // Animate camera towards user when button is pressed
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
        <Animated.View style={[styles.myLocationContainer, animationStyle]} >
            <TouchableOpacity
                style={[styles.myLocationButton]}
                onPress={handlePress}
            >
                <Image source={require("../assets/user-location.png")} style={styles.myLocationIcon} />
            </TouchableOpacity>
    </Animated.View>
    )
}


const styles = StyleSheet.create({
    myLocationContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 60,
        position: 'absolute',
        bottom: 15,
        right: 15,
        height: 60,
        elevation: 2,
        zIndex: 2
    },

    myLocationButton: {
        backgroundColor: '#fff',
        borderRadius: 100,
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 0,
        },
        shadowOpacity: 0.36,
        shadowRadius: 6.68,
        height: 60,
        width: 60,
        alignItems: 'center',
        justifyContent: 'center',
    },

    myLocationIcon: {
        width: 30,
        height: 30
    }
});

export default CurrentLocationButton;