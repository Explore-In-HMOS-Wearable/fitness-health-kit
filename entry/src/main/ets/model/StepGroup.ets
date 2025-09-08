import { SampleSet } from './SampleSet';

export interface StepGroup {
  startTime: number;
  endTime: number;
  sampleSet: SampleSet[];
}