import { StepValue } from './StepValue';

export interface SamplePoint {
  startTime: number;
  endTime: number;
  dataTypeName: string;
  value: StepValue[];
}