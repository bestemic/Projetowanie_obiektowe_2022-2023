import {ScrollView, StyleSheet, Text, View} from 'react-native';
import {useContext} from "react";
import {CartContext} from "../context/CartContext";

const Cart = () => {
    const {cartItems} = useContext(CartContext);

    const renderProduct = (product, index) => {
        return (
            <View style={styles.card} key={index}>
                <Text style={styles.name}>{product.name}</Text>
                <Text style={styles.price}>Price: {product.price} USD</Text>
                <Text style={styles.price}>Quantity: {product.quantity}</Text>
            </View>
        );
    };

    return (
        <ScrollView contentContainerStyle={{alignItems: 'center', justifyContent: 'center'}} style={{flex: 1}}>
            <Text style={{fontSize: 20, fontWeight: 'bold',}}>{"\n\n"}Cart{"\n"}</Text>
            {cartItems.map((product, index) => renderProduct(product, index))}
        </ScrollView>
    );
}

export default Cart;

const styles = StyleSheet.create({
    card: {
        backgroundColor: '#ffffff',
        padding: 20,
        marginBottom: 20,
        paddingHorizontal: 50,
    },
    name: {
        fontSize: 30,
        fontWeight: 'bold',
        marginBottom: 8,
    },
    price: {
        fontSize: 20,
        marginBottom: 8,
    }
});