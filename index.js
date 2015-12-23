import React from 'react-native';

var device = React.NativeModules.Device;

class Device {
	constructor() {
		this.suspend = this.suspend.bind(this);
		this.resume = this.resume.bind(this);
		this.orientationChange = this.orientationChange.bind(this);
		React.NativeAppEventEmitter.addListener('suspend', this.onSuspend);
		React.NativeAppEventEmitter.addListener('resume', this.onResume);
		React.NativeAppEventEmitter.addListener('orientationchange', this.onOrientationChange);
		this.getInfo(() => React.DeviceEventEmitter.emit('deviceready'));
	}

	onSuspend() {
		React.DeviceEventEmitter.emit('suspend');
	}

	onResume() {
		React.DeviceEventEmitter.emit('resume');
	}

	getInfo(callback) {
		device.info((info) => {
			Object.assign(this, info);
			callback();
		});
	}

	onOrientationChange() {
		this.getInfo(() => React.DeviceEventEmitter.emit('orientationchange'));
	}
}

export default new Device()
