import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Concurrent
export function processRespTask(err: BusinessError, data: http.HttpResponse) {
  if (!err) {
    console.info('Result:' + data.result);
    console.info('code:' + data.responseCode);
    console.info('type:' + JSON.stringify(data.resultType));
    console.info('header:' + JSON.stringify(data.header));
    console.info('cookies:' + data.cookies);
  } else {
    console.info('error:' + JSON.stringify(err));
  }
}