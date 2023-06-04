import {createDrawerNavigator} from '@react-navigation/drawer';
import {NavigationContainer} from '@react-navigation/native';
import Home from "../components/Home";
import Cart from "./Cart";

const Drawer = createDrawerNavigator();

const Menu = () => (
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
        </Drawer.Navigator>
    </NavigationContainer>
);

export default Menu