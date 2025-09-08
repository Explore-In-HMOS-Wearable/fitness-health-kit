import { ExerciseViewModel } from '../viewmodel/ExerciseViewModel';
import ExerciseModel from '../model/ExerciseModel';
import { ExerciseCardComponent } from '../component/ExerciseCardComponent';

@Entry
@Component
struct ExercicesPage {
  scroller: Scroller = new Scroller()
  @State viewModel: ExerciseViewModel = ExerciseViewModel.instance;

  // get  exercises when open the page
  aboutToAppear() {
    this.viewModel.getExercises()
  }

  build() {
    Column() {
      Text($r('app.string.exercises'))

      Scroll(this.scroller) {
        Column() {
          ForEach(this.viewModel.allExercises, (exercise: ExerciseModel, index: number) => {
            ExerciseCardComponent({
              image: exercise.image,
            }).padding({ bottom: 4 })
            Divider().height(2).color(0xCCCCCC).padding({ left: 20, right: 20, bottom: 10 });
          }, (item: string, index: number) => item)
        }.padding({ bottom: 25 })
      }.width('100%').height('100%')
    }
    .backgroundColor(Color.Grey)
    .padding({
      top: 10,
      bottom: 10,
      right: 40,
      left: 40
    })
    .width('100%')
    .height('100%')
  }
}