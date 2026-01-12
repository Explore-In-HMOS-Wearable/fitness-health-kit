import { ButtonComponent } from '../component/ButtonComponent';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@Entry
@Component
struct HomePage {
  @Consume('mainStack') pathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        ButtonComponent({ text: $r('app.string.exercises') }).margin({ bottom: 5 })
          .onClick(() => {
            this.pathStack.pushPathByName('ExercisesPage', null)
          })

        ButtonComponent({ text: $r('app.string.heart_rate') }).margin({ bottom: 5 })
          .onClick(() => {
            this.pathStack.pushPathByName('HeartRatePage', null)
          })

        ButtonComponent({ text: $r('app.string.timer') }).margin({ bottom: 5 })
          .onClick(() => {
            this.pathStack.pushPathByName('PrepareRound', null)
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}