import {createDrawerNavigator} from '@react-navigation/drawer';
import {NavigationContainer} from '@react-navigation/native';
import Home from "../components/Home";
import Cart from "./Cart";
import Products from "./Products";
import {useEffect, useState} from "react";
import {getCategories} from "../services/categories";

const Drawer = createDrawerNavigator();

const Menu = () => {
    const [categories, setCategories] = useState([]);


    const renderProductsScreen = (category) => {
        console.log(category)
        return () => <Products category={category}/>;
    };

    useEffect(() => {
        const categories = getCategories();
        setCategories(categories);
    }, []);

    return (
        <NavigationContainer>
            <Drawer.Navigator initialRouteName="Home">
                <Drawer.Screen
                    name="Home"
                    component={Home}
                    options={{drawerLabel: 'Home'}}
                />
                <Drawer.Screen
                    name="Cart"
                    component={Cart}
                    options={{drawerLabel: 'Cart'}}
                />
                {categories.map((category) => (
                    <Drawer.Screen
                        key={category.id}
                        name={category.name}
                        component={renderProductsScreen(category)}
                        options={{drawerLabel: category.name}}
                    />
                ))}
            </Drawer.Navigator>
        </NavigationContainer>
    );
}

export default Menu