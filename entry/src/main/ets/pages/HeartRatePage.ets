import { HeartRateViewModel } from '../viewmodel/HeartRateViewModel';

@Entry
@Component
export struct HeartRatePage {
  private viewModel = new HeartRateViewModel();
  @State heartRate: number = 0;

  aboutToAppear() {
    this.viewModel.setHeartRateCallback((value: number) => {
      this.heartRate = value;
    });
    this.viewModel.requestHealthPermission();
  }

  build() {
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
                  count: 255,
                },
              },
              color: { range: [Color.White, Color.Red] },
            },
          ]
        }).width(200).height(200)
      }.width('10%').height('10%').align(Alignment.Top)

      Image($r('app.media.heartrate')).width(50).height(50).margin({ bottom: 10 })
      Text('Heart Rate: ' + this.heartRate + ' bpm')
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
}
