import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Concurrent
export function processRespTask(err: BusinessError, data: http.HttpResponse) {
  if (!err) {
    console.info(`Result: ${data.result}`);
    console.info(`Code: ${data.responseCode}`);
    console.info(`Type: ${JSON.stringify(data.resultType)}`);
    console.info(`Header: ${JSON.stringify(data.header)}`);
    console.info(`Cookies: ${data.cookies}`);
  } else {
    console.info(`Error: ${JSON.stringify(err)}`);
  }
}
