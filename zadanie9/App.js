import Menu from "./components/Menu";
import {CartProvider} from "./context/CartContext";

export default function App() {

    return (
        <CartProvider>
            <Menu/>
        </CartProvider>
    );
}
