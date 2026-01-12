import { getHttp } from '../utils/RCP';
import ExerciseModel from '../model/ExerciseModel';
import { RSPModel } from '../model/RSPModel';
import { getUrl } from '../utils/RCPConstants';

@Observed
export class ExerciseViewModel {
  private static _instance: ExerciseViewModel;
  allExercises: ExerciseModel[] = []
  pixelMapImg: PixelMap | undefined = undefined;

  private constructor() {
  }

  public static get instance(): ExerciseViewModel {
    if (!ExerciseViewModel._instance) {
      ExerciseViewModel._instance = new ExerciseViewModel();
    }
    return ExerciseViewModel._instance;
  }

  async getExercises() {
    const response = await getHttp(getUrl()) ?? []
    const rsp = response as RSPModel;
    this.allExercises = rsp.results;

    console.info('getExercises', JSON.stringify(this.allExercises, null, 2));
  }
}