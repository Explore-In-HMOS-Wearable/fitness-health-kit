import { SamplePoint } from './SamplePoint';

export interface SampleSet {
  dataCollectorId: string;
  samplePoints: SamplePoint[];
}