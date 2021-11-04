import {Dimensions, StyleSheet, Text, View} from "react-native";
import * as React from "react";

function Header() {
    return (
        <View style={styles.header}>
            <Text>
                <Text style={styles.headerText}>ECO</Text><Text style={styles.headerTextBold}>CHAT</Text>
            </Text>
        </View>
    )
}

const styles = StyleSheet.create({
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

export default Header;