import { curves } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private timerId = 0;
  @State imageTranslateY: number = 300;
  @State textOffsetY: number = -50;
  textOpacity: number = 0;
  @Provide('mainStack') pathStack: NavPathStack = new NavPathStack()

  aboutToAppear() {
    setTimeout(() => {
      this.textOffsetY = 0;
      this.textOpacity = 1;
    }, 100);

    setTimeout(() => {
      this.imageTranslateY = 10;
    }, 300);

    this.timerId = setTimeout(() => {
      this.pathStack.pushPath({
        name: 'QRPage'
      });
    }, 3000);
  }

  onDestroy() {
    if (this.timerId) {
      clearTimeout(this.timerId);
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Text($r('app.string.splash_text'))
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .translate({ y: this.textOffsetY })
          .animation({
            curve: curves.initCurve(),
            iterations: 1,
            duration: 800,
            playMode: PlayMode.Normal
          })

        Image($r('app.media.splash'))
          .height(50)
          .width(50)
          .translate({ y: this.imageTranslateY })
          .animation({
            curve: curves.initCurve(),
            iterations: 1,
            duration: 1000,
            playMode: PlayMode.Normal
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }
}
