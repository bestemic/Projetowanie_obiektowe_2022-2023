import {ScrollView, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import {useEffect, useState} from "react";
import {getProducts} from "../services/products";

const Products = ({category}) => {
    const [products, setProducts] = useState([]);

    useEffect(() => {
        const products = getProducts(category.id);
        setProducts(products);
    }, [category]);

    const renderProduct = (product) => {
        return (
            <View style={styles.card} key={product.id}>
                <Text style={styles.name}>{product.name}</Text>
                <Text style={styles.price}>Price: {product.price} USD</Text>
                <TouchableOpacity style={styles.button} onPress={() => addToCart(product)}>
                    <Text>Buy</Text>
                </TouchableOpacity>
            </View>
        );
    };

    const addToCart = (product) => {
        console.log('Added to cart:', product);
    };

    return (
        <ScrollView contentContainerStyle={{alignItems: 'center', justifyContent: 'center'}} style={{flex: 1}}>
            <Text style={{fontSize: 30, fontWeight: 'bold',}}>{"\n\n"}Products for category</Text>
            <Text style={{fontSize: 30, fontWeight: 'bold',}}>{category.name.toLowerCase()}{"\n"}</Text>
            {products.map((product) => renderProduct(product))}
        </ScrollView>
    );
}

export default Products;

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
    },
    button: {
        backgroundColor: '#b70101',
        borderRadius: 4,
        paddingVertical: 8,
        paddingHorizontal: 12,
        alignItems: 'center',
    }
});