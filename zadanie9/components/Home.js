import {Image, Text, View} from 'react-native';
import CartBadge from "./CartBadge";

const Home = ({navigation}) => {

    return (
        <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
            <CartBadge navigation={navigation}/>
            <Image
                source={require('../assets/adaptive-icon.png')}
                style={{width: 150, height: 150, alignSelf: 'center'}}
            />
            <Text style={{fontSize: 20, fontWeight: 'bold',}}>{"\n\n"}Welcome in the mobile shop!</Text>
        </View>
    );
}

export default Home;