/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  Component,
  StyleSheet,
  Text,
  View,
} = React;

const Device = React.NativeModules.Device;

class DeviceDemo extends Component{
  componentDidMount() {
    this.state = null
    React.NativeAppEventEmitter.addListener('orientationchange', () => { 
      Device.info((info) => {
        console.log('orientationchange ' + info.orientation + ' ' + info.width + ' x ' + info.height)
        console.dir(info)
        this.setState(info)
      });
    });
    Device.info((info) => {
      console.log("info")
      this.setState(info)
    });
  }

  render() {
    console.log("render")
    if (!this.state) {
      return <View/>
    }
    switch (this.state.orientation) {
      case 'Portrait':
      case 'PortraitUpsideDown':
        return (
          <View style={styles.container}>
            <Text style={styles.welcome}>
              Welcome to React Native!
            </Text>
            <Text>{this.state.name}</Text>
            <Text>{this.state.systemName + ' ' + this.state.systemVersion}</Text>
            <Text>
              {this.state.orientation + ' ' + this.state.width + ' x ' + this.state.height}
            </Text>
            <Text>Customized for Portrait</Text>
          </View>
        )
      case 'Landscape':
      case 'LandscapeLeft':
      case 'LandscapeRight':
        return (
          <View style={styles.container}>
            <Text style={styles.welcome}>
              Welcome to React Native!
            </Text>
            <Text>{this.state.name}</Text>
            <Text>{this.state.systemName + ' ' + this.state.systemVersion}</Text>
            <Text>
              {this.state.orientation + ' ' + this.state.width + ' x ' + this.state.height}
            </Text>
            <Text>Customized for Landscape</Text>
          </View>
        )

    }
  }
}

var styles = StyleSheet.create({
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

AppRegistry.registerComponent('DeviceDemo', () => DeviceDemo);
