import PermissionsUtil from '../utils/PermissionsUtil';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
export function HeartRatePageBuilder() {
  HeartRatePage()
}

@Entry
@Component
export struct HeartRatePage {
  @State heartRate: number = 0;
  @Consume('mainStack') pathStack: NavPathStack;
  private uiContext = this.getUIContext();
  private realContext = this.uiContext.getHostContext()

  aboutToAppear() {
    const INTERVAL = 200000000;
    PermissionsUtil.requestPermissions([
      'ohos.permission.READ_HEALTH_DATA'], this.realContext!)
    sensor.getSensorList((error: BusinessError, data: Array<sensor.Sensor>) => {
      if (error) {
        console.error('getSensorList failed');
      } else {
        console.info('getSensorList success');
        for (let i = 0; i < data.length; i++) {
          console.info(JSON.stringify(data[i]));
        }
      }
    })
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
        this.heartRate = data.heartRate
      }, { interval: INTERVAL });
      setTimeout(() => {
        sensor.off(sensor.SensorId.HEART_RATE);
      }, 500);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
  }

  aboutToDisappear(): void {
    sensor.off(sensor.SensorId.HEART_RATE);
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Text()
            .width(300).height(300).backgroundColor(Color.Black)
          Particle({
            particles: [
              {
                emitter: {
                  particle: {
                    type: ParticleType.POINT,
                    config: { radius: 5 },
                    count: 255
                  }
                },
                color: { range: [Color.White, Color.Red] }
              }
            ]
          }).width(200).height(200)
        }.width('10%').height('10%').align(Alignment.Top)

        Image($r('app.media.heartrate')).width(50).height(50).margin({ bottom: 10 })
        Text(`Heart Rate: ${this.heartRate} bpm`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideBackButton(true)
  }
}