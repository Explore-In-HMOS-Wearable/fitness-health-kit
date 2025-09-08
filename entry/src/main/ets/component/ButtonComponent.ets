@Component
export struct ButtonComponent {
  @Prop text: ResourceStr

  build() {
    Button(this.text)
      .width('70%')
      .height(40)
      .fontSize(16)
      .fontWeight(FontWeight.Medium)
      .backgroundColor('#243A6A')
      .borderRadius(22)
  }
}