@Builder
export function QRPageBuilder() {
  QRPage()
}

@Entry
@Component
export struct QRPage {
  @Consume('mainStack') pathStack: NavPathStack;

  build() {
    NavDestination() {

      Column() {
        Image($r('app.media.splash'))
          .height('15%')
          .margin({ bottom: 10 })
        Text($r('app.string.qr'))
          .margin({ bottom: 10 })
        Image($r('app.media.qrcode'))
          .height('35%')
          .onClick(() => {
            this.pathStack.pushPathByName('AuthenticationPage', null)
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .hideBackButton(true)
  }
}