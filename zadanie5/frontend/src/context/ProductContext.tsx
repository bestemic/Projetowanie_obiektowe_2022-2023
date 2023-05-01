import React, {useEffect, useState} from "react";
import {Product} from "../interfaces/ProductInterface";
import getProducts from "../api/ProductsApi";
import {ShopContextState} from "../interfaces/ShopContextStateInterface";

export const ProductContext = React.createContext<ShopContextState | undefined>(undefined);

type Props = {
    children: React.ReactNode;
};

export const ProductContextProvider = ({children}: Props) => {
    const [products, setProducts] = useState<Product[]>([]);

    const providerValue: ShopContextState = {
        products,
    }

    useEffect(() => {
        getProducts().then((products) => setProducts(products))
    }, []);

    return (
        <ProductContext.Provider value={providerValue}>{children}</ProductContext.Provider>
    );
};

export default ProductContext;