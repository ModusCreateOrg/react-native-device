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
  SegmentedControlIOS,
} = React;

import Device from 'react-native-device';

class DeviceInfo extends Component {
  render() {
    return (
      <View style={{borderWidth: 1, padding: 5, marginBottom: 10}}>
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

class RotationLockControl extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      selectedIndex: 0,
    };
    this.onValueChange = this.onValueChange.bind(this);
  }
  render() {
    return (
      <View style={{marginTop: 10, marginBottom: 10}}>
        <Text>Lock Orientation:</Text>
        <SegmentedControlIOS 
          style={{flex: 1}}
          selectedIndex={this.state.selectedIndex}
          values={["None", "Portrait", "LandscapeLeft", "LandscapeRight"]}
          onValueChange={this.onValueChange}
        />
      </View>
    );
  }
  onValueChange(value) {
    console.log(value)
    switch (value) {
      case 'Portrait':
        // React.NativeModules.MCDevice.lockOrientation('Portrait')
        Device.lockOrientation('Portrait');
        this.setState({
          selectedIndex: 1
        });
        break;
      case 'LandscapeLeft':
        Device.lockOrientation('LandscapeLeft');
        this.setState({
          selectedIndex: 2
        });
        break;
      case 'LandscapeRight':
        Device.lockOrientation('LandscapeRight');
        this.setState({
          selectedIndex: 3
        });
        break;
      default:
        Device.unlockOrientation();
        this.setState({
          selectedIndex: 0
        });
        break;
    }
  }
}

class PhonePortrait extends Component {
  render() {
    return <View style={styles.custom}><Text>PhonePortrait</Text></View>
  }
  onChange() {

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
class example extends Component{
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
              react-native-device Demo
            </Text>
            {this.renderProfile()}
            <RotationLockControl/>
            <DeviceInfo {...this.state}/>
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
    padding: 5,
    // justifyContent: 'center',
    flex: 1,
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    marginTop: 40,
    alignItems: 'center',
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

AppRegistry.registerComponent('example', () => example);
