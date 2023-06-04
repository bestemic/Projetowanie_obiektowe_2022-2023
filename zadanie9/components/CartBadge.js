import React, {useContext} from 'react';
import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import {CartContext} from '../context/CartContext';

const CartBadge = ({navigation}) => {
    const {getCount} = useContext(CartContext);
    
    return (
        <TouchableOpacity style={styles.container} onPress={() => navigation.navigate('Cart')}>
            <View>
                <Text style={styles.text}>{getCount()}</Text>
            </View>
        </TouchableOpacity>
    );
};

const styles = StyleSheet.create({
    container: {
        position: 'absolute',
        top: 20,
        right: 20,
        backgroundColor: 'red',
        borderRadius: 10,
        width: 40,
        height: 40,
        justifyContent: 'center',
        alignItems: 'center',
    },
    text: {
        color: 'white',
        fontSize: 15,
        fontWeight: 'bold',
    },
});

export default CartBadge;
