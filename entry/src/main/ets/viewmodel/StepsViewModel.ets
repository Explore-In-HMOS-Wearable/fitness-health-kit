import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { getSampleSet } from '../utils/RCPConstants';
import { PolymerizeWithItem } from '../model/PolymerizeWithItem';
import { StepResponse } from '../model/StepResponse';
import { StepGroup } from '../model/StepGroup';
import { SampleSet } from '../model/SampleSet';
import { SamplePoint } from '../model/SamplePoint';
import { StepValue } from '../model/StepValue';
import { StepDataResult } from '../model/StepDataResult';
import taskpool from '@ohos.taskpool';
import { processRespTask } from '../common/processRespTask';

export class StepsViewModel {
  // Nanosecond to millisecond conversion helper
  private nanoToMillis(nano: number): number {
    return Math.floor(nano / 1_000_000);
  }

  // fetch step data
  async fetchStepData(accessToken: string): Promise<StepDataResult> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();
      const url = getSampleSet();

      const polymerizeWith: PolymerizeWithItem[] = [
        { dataTypeName: 'com.huawei.continuous.steps.delta' }
      ];

      const body = JSON.stringify({
        polymerizeWith: polymerizeWith,
        startTime: 1759494465000,
        endTime: 1761913665000
      });

      const headers: Record<string, string> = {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      };

      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: headers,
          extraData: body,
          expectDataType: http.HttpDataType.STRING
        },
        async (err: BusinessError, data: http.HttpResponse) => {
          let task = new taskpool.Task(processRespTask, [err, data]);
          await taskpool.execute(task);

          const result = typeof data.result === 'string' ?
            JSON.parse(data.result) as StepResponse :
            data.result as StepResponse;

          const steps: number[] = [];
          const times: string[] = [];

          result.group.forEach((groupItem: StepGroup) => {
            groupItem.sampleSet.forEach((set: SampleSet) => {
              set.samplePoints.forEach((point: SamplePoint) => {
                point.value.forEach((v: StepValue) => {
                  if (v.fieldName === 'steps_delta') {
                    const formatter = new Intl.DateTimeFormat(undefined, {
                      dateStyle: 'short',
                      timeStyle: 'medium'
                    });

                    const startMillis = this.nanoToMillis(point.startTime);
                    const endMillis = this.nanoToMillis(point.endTime);

                    const startDate = formatter.format(startMillis);
                    const endDate = formatter.format(endMillis);

                    steps.push(v.integerValue);
                    times.push(startDate.toLocaleString());
                    times.push(endDate.toLocaleString());
                    let task = new taskpool.Task(processRespTask, [err, data]);
                    taskpool.execute(task);
                    console.info(`Steps: ${v.integerValue} startTime: ${startDate.toLocaleString()} endTime: ${endDate.toLocaleString()} `);
                  }
                });
              });
            });
          });

          resolve({ steps, times });
        }
      );
    });
  }

  getSteps(accessToken: string): Promise<StepDataResult> {
    return this.fetchStepData(accessToken);
  }
}