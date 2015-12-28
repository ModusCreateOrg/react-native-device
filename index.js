import React from 'react-native';

var device = React.NativeModules.Device;

class Device {
	/**
	 *
	 */
	constructor() {
		this.onSuspend = this.onSuspend.bind(this);
		this.onResume = this.onResume.bind(this);
		this.onOrientationChange = this.onOrientationChange.bind(this);
		React.NativeAppEventEmitter.addListener('suspend', this.onSuspend);
		React.NativeAppEventEmitter.addListener('resume', this.onResume);
		React.NativeAppEventEmitter.addListener('orientationchange', this.onOrientationChange);
		this.getInfo(() => React.DeviceEventEmitter.emit('deviceready'));
	}

	/**
	 *
	 */
	onSuspend() {
		React.DeviceEventEmitter.emit('suspend');
	}

	/**
	 *
	 */
	onResume() {
		React.DeviceEventEmitter.emit('resume');
	}

	/**
	 *
	 */
	getInfo(callback) {
		device.info((info) => {
			Object.assign(this, info);
			callback();
		});
	}

	/**
	 *
	 */
	onOrientationChange() {
		this.getInfo(() => React.DeviceEventEmitter.emit('orientationchange'));
	}

	/**
	 *
	 */
	lockOrientation(orientation) {
		device.lockOrientation(orientation)
	}

	/**
	 *
	 */
	unlockOrientation() {
		device.unlockOrientation()
	}
}

export default new Device()
