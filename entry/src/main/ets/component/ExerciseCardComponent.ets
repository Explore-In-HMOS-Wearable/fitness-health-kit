@Component
export struct ExerciseCardComponent {
  @Prop image: string

  build() {
    Image(this.image).padding({ bottom: 3 }).width('%5').height('%1')
  }
}