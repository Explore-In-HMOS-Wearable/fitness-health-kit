import { ButtonComponent } from '../component/ButtonComponent';
import { TimerButtonComponent } from '../component/TimerButtonComponent';
import { INavParams } from '../model/INavParams';
import { RoundViewModel } from '../viewmodel/RoundViewModel';

@Builder
export function PrepareRoundPageBuilder() {
  PrepareRound()
}

@Entry
@Component
export struct PrepareRound {
  private viewModel = new RoundViewModel();
  @State fastDuration: number = this.viewModel.fastDuration;
  @State slowDuration: number = this.viewModel.slowDuration;
  @State repetitions: number = this.viewModel.repetitions;
  @Consume('mainStack') pathStack: NavPathStack;

  private syncState() {
    this.fastDuration = this.viewModel.fastDuration;
    this.slowDuration = this.viewModel.slowDuration;
    this.repetitions = this.viewModel.repetitions;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          TimerButtonComponent({
            text: $r('app.string.fast'),
            duration: `${this.fastDuration} sc`,
            handlers: {
              onIncrease: () => {
                this.viewModel.increaseFast();
                this.syncState();
              },
              onDecrease: () => {
                this.viewModel.decreaseFast();
                this.syncState();
              }
            }
          })

          TimerButtonComponent({
            text: $r('app.string.slow'),
            duration: `${this.slowDuration} sc`,
            handlers: {
              onIncrease: () => {
                this.viewModel.increaseSlow();
                this.syncState();
              },
              onDecrease: () => {
                this.viewModel.decreaseSlow();
                this.syncState();
              }
            }
          })

          TimerButtonComponent({
            text: $r('app.string.round'),
            duration: this.repetitions.toString(),
            handlers: {
              onIncrease: () => {
                this.viewModel.increaseReps();
                this.syncState();
              },
              onDecrease: () => {
                this.viewModel.decreaseReps();
                this.syncState();
              }
            }
          })

          ButtonComponent({ text: $r('app.string.start') }).margin({ top: 8 })
            .onClick(() => {
              this.pathStack.pushPath({
                name: 'Timer',
                param: {
                  fastDuration: this.fastDuration,
                  slowDuration: this.slowDuration,
                  repetitions: this.repetitions
                } as INavParams
              })
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 24, left: 10, right: 10 })
      }
      .height('100%')
    }
    .hideBackButton(true)
  }
}