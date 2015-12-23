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

import Device from 'react-native-device';

class DeviceInfo extends Component {
  render() {
    return (
      <View>
        <Text style={{fontSize: 16}}>Device Info</Text>
        <Text>name: {this.props.name}</Text>
        <Text>systemName: {this.props.systemName}</Text>
        <Text>systemVersion: {this.props.systemVersion}</Text>
        <Text>orientation: {this.props.orientation}</Text>
        <Text>orientationMask: {this.props.orientationMask}</Text>
        <Text>width,height: {this.props.width + ' x ' + this.props.height}</Text>
      </View>
    )
  }
}

class PhonePortrait extends Component {
  render() {
    return <View style={styles.custom}><Text>PhonePortrait</Text></View>
  }
}
class PhoneLandscape extends Component {
  render() {
    return <View style={styles.custom}><Text>PhoneLandscape</Text></View>
  }
}
class TabletPortrait extends Component {
  render() {
    return <View style={styles.custom}><Text>TabletPortrait</Text></View>
  }
}
class TabletLandscape extends Component {
  render() {
    return <View style={styles.custom}><Text>TabletLandscape</Text></View>
  }
}
class DeviceDemo extends Component{
  constructor(props, context) {
    super(props, context);
    this.state = {}
  }

  componentDidMount() {
    React.DeviceEventEmitter.addListener('orientationchange', () => { 
        console.log('orientationchange ' + Device.orientation + ' ' + Device.width + ' x ' + Device.height);
        console.dir(Device);
        this.setState(Object.assign({}, Device));
    });
    React.DeviceEventEmitter.addListener('deviceready', () => {
        this.setState(Object.assign({}, Device))
    });

    React.DeviceEventEmitter.addListener('suspend', () => { console.log('suspend')});
    React.DeviceEventEmitter.addListener('resume', () => { console.log('resume')});
  }

  render() {
    console.log("render")
        return (
          <View style={styles.container}>
            <Text style={styles.welcome}>
              Welcome to React Native!
            </Text>
            <DeviceInfo {...this.state}/>
            {this.renderProfile()}
          </View>
        )
    }

    renderProfile() {
      switch (this.state.orientation) {
        case 'Portrait':
        case 'PortraitUpsideDown':
          return Device.userInterfaceIdiom === 'Phone' ? <PhonePortrait/> : <TabletPortrait/>;
        case 'Landscape':
        case 'LandscapeLeft':
        case 'LandscapeRight':
          return Device.userInterfaceIdiom === 'Phone' ? <PhoneLandscape/> : <TabletLandscape/>; 
      }
    }
}

var styles = StyleSheet.create({
  custom: {
    borderWidth: 2,
    padding: 5
  },
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
