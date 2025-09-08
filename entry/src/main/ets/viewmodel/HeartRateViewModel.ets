import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';

export class HeartRateViewModel {
  heartRate: number = 0;
  private onHeartRateChange: (value: number) => void = () => {};

  setHeartRateCallback(callback: (value: number) => void) {
    this.onHeartRateChange = callback;
  }

  async requestHealthPermission(): Promise<void> {
    const context = getContext(this);
    const atManager = abilityAccessCtrl.createAtManager();
    const permissions: Permissions[] = [
      'ohos.permission.READ_HEALTH_DATA',
      'ohos.permission.GET_NETWORK_INFO',
      'ohos.permission.INTERNET'
    ];

    try {
      const result = await atManager.requestPermissionsFromUser(context, permissions);
      console.info('Permissions granted: ' + JSON.stringify(result));
      if (result.authResults.every(r => r === 0)) {
        console.info('All permissions granted');
        this.subscribeHeartRateSensor();
      } else {
        console.error('One or more permission rejected.');
      }
    } catch (err) {
      console.error('Failed to get permission: ' + JSON.stringify(err));
    }
  }

  private subscribeHeartRateSensor() {
    sensor.getSensorList((error: BusinessError, data: Array<sensor.Sensor>) => {
      if (error) {
        console.error('getSensorList error: ' + JSON.stringify(error));
        return;
      }

      const heartRateSensor = data.find(s => s.sensorName.toLowerCase().includes('heart'));
      if (!heartRateSensor) {
        console.error('Heart rate sensor cannot be found');
        return;
      }

      console.info('Heart rate sensor found ' + JSON.stringify(heartRateSensor));

      sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
        if (data && data.heartRate !== undefined) {
          this.heartRate = data.heartRate;
          this.onHeartRateChange(data.heartRate);
        }
      }, { interval: 100000000 }); // 100ms
    });
  }
}
