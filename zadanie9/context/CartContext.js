import {createContext, useState} from 'react';

const CartContext = createContext();

const CartProvider = ({children}) => {
    const [cartItems, setCartItems] = useState([]);

    const addToCart = ((product) => {
        const existingProduct = cartItems.find((i) => i.id === product.id);

        if (existingProduct) {
            setCartItems((prevItems) =>
                prevItems.map((i) =>
                    i.id === product.id ? {...i, quantity: i.quantity + 1} : i
                )
            );
        } else {
            setCartItems((prevItems) => [...prevItems, {...product, quantity: 1}]);
        }
    });

    const getCount = (() => {
        return cartItems.reduce((acc, product) => {
            return acc+product.quantity
        }, 0)
    });


    return (
        <CartContext.Provider
            value={{cartItems, addToCart, getCount}}
        >
            {children}
        </CartContext.Provider>
    );
};

export {CartContext, CartProvider};