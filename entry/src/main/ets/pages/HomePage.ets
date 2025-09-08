import { router } from '@kit.ArkUI';
import { ButtonComponent } from '../component/ButtonComponent';

@Entry
@Component
struct HomePage {
  build() {
    Column() {
      ButtonComponent({ text: $r('app.string.exercises') }).margin({ bottom: 5 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/ExercisesPage' })
        })

      ButtonComponent({ text: $r('app.string.heart_rate') }).margin({ bottom: 5 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HeartRatePage' })
        })
      ButtonComponent({ text: $r('app.string.timer') }).margin({ bottom: 5 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/PrepareRound' })
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}