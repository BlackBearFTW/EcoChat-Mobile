import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
    apiKey: "AIzaSyCTinB9uZa3foLvQXP5UtNHZks4kLUYOLk",
    authDomain: "ecochat-mobile.firebaseapp.com",
    projectId: "ecochat-mobile",
    storageBucket: "ecochat-mobile.appspot.com",
    messagingSenderId: "700388965972",
    appId: "1:700388965972:web:b3254ed195802890fe77c1",
    measurementId: "G-RN8BTSN05N"
};

const app = initializeApp(firebaseConfig);

const db = getFirestore();

export default db;
