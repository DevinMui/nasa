/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {
  AppRegistry,
  Component,
  StyleSheet,
  Text,
  View
} from 'react-native';
var url = "http://nasa.devinmui.xyz"
var id = ""
var { RNLocation: Location } = require('NativeModules');
var { DeviceEventEmitter } = React;
Location.requestAlwaysAuthorization();
Location.startUpdatingLocation();
Location.setDistanceFilter(5.0);
var subscription = DeviceEventEmitter.addListener(
  'locationUpdated',
  (location) => {
    fetch(url + '/flight', {
      body: JSON.stringify({
        id: id,
        headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }
      })
    })
    .then((response) => response.text())
    .then((responseText) => {
      var long1 = location.coords.longitude
      var lat1 = location.coords.latitude
      var long2 = responseText.long
      var lat1 = responseText.lat
      if((long2 - 0.0002 < long1 < long2 + 0.0002) && (lat2 - 0.0002 < lat2 < lat2 + 0.0002)){
        fetch(url + '/reached', {
          method: 'POST',
          headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' }
        })
      }
    })
  }
);

class iosGPS extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('iosGPS', () => iosGPS);
