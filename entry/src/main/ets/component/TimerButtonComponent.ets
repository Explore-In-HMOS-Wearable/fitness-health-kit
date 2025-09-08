export interface TimerButtonHandlers {
  onIncrease: () => void;
  onDecrease: () => void;
}

@Component
export struct TimerButtonComponent {
  @Prop text: ResourceStr
  @Prop duration: string
  @Prop handlers: TimerButtonHandlers;

  build() {
    Row() {
      Text(this.text)
        .fontSize(18)
        .fontColor(Color.White)
        .width('30%')
        .textAlign(TextAlign.Start)

      Row() {
        Button('-')
          .fontSize(18)
          .fontColor(Color.White)
          .backgroundColor('transparent')
          .onClick(() => {
            this.handlers.onDecrease();
          })

        Text(this.duration)
          .fontSize(18)
          .fontColor(Color.White)
          .width(50)
          .textAlign(TextAlign.Center)

        Button('+')
          .fontSize(18)
          .fontColor(Color.White)
          .backgroundColor('transparent')
          .onClick(() => {
            this.handlers.onIncrease();
          })
      }
      .width('64%')
      .height(34)
      .borderRadius(22)
      .backgroundColor('#333333')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('90%')
    .height(40)
    .margin({ bottom: 6 })
  }
}