import { router } from '@kit.ArkUI'

@Entry
@Component
export struct QRPage {
  build() {

    Column() {
      Image($r('app.media.splash'))
        .height('15%')
        .margin({ bottom: 10 })
      Text($r('app.string.qr'))
        .margin({ bottom: 10 })
      Image($r('app.media.qrcode'))
        .height('35%')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AuthenticationPage' })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

  }
}