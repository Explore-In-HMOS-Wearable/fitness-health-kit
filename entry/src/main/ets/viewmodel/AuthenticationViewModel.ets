import Preferences from '../common/Preferences';
import { APIConstants } from '../common/Constants';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { TokenResponse } from '../model/TokenResponse';
import { getAuthUrl } from '../utils/RCPConstants';
import taskpool from '@ohos.taskpool';
import { processRespTask } from '../common/processRespTask';

export class AuthenticationViewModel {
  accessToken: string = '';
  activationKey: string = '';

  getAccessTokenFromStorage(): string {
    const token = Preferences.instance.getPreference('accessToken');
    this.accessToken = token;
    return token;
  }

  saveTokens(accessToken: string, refreshToken: string) {
    Preferences.instance.putPreference('accessToken', accessToken);
    Preferences.instance.putPreference('refreshToken', refreshToken);
    this.accessToken = accessToken;
  }

  getQueryParameter(url: string, paramName: string): string | null {
    const queryStartIndex = url.indexOf('?');
    if (queryStartIndex === -1) {
      return null;
    }

    const queryString = url.substring(queryStartIndex + 1);
    const params = queryString.split('&');

    for (const param of params) {
      const parts = param.split('=');
      if (parts.length === 2) {
        const key = decodeURIComponent(parts[0]);
        const value = decodeURIComponent(parts[1]);
        if (key === paramName) {
          return value;
        }
      }
    }

    return null;
  }

  async postOAuthToken(code: string): Promise<string | null> {
    const httpRequest = http.createHttp();

    const body =
      'grant_type=authorization_code' +
        `&code=${encodeURIComponent(code)}` +
        `&client_id=${encodeURIComponent(APIConstants.CLIENT_ID)}` +
        `&client_secret=${encodeURIComponent(APIConstants.CLIENT_SECRET)}` +
        `&redirect_uri=${encodeURIComponent(APIConstants.REDIRECT_URL)}`;

    return new Promise((resolve, reject) => {
      httpRequest.request(
        getAuthUrl(),
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          extraData: body,
          expectDataType: http.HttpDataType.STRING
        },
        async (err: BusinessError, data) => {
          let task = new taskpool.Task(processRespTask, [err, data]);
          await taskpool.execute(task);

          let parsed: TokenResponse | null = null;

          if (typeof data.result === 'string') {
            try {
              parsed = JSON.parse(data.result) as TokenResponse;
            } catch (e) {
              console.error('JSON parse failed:', e);
              resolve(null);
              return;
            }
          } else if (typeof data.result === 'object') {
            parsed = data.result as TokenResponse;
          }

          if (parsed && parsed.accessToken && parsed.refreshToken) {
            this.saveTokens(parsed.accessToken, parsed.refreshToken);
            resolve(parsed.accessToken);
          } else {
            console.error('Token parse error or missing fields:', parsed);
            resolve(null);
          }

        }
      );
    });
  }
}
