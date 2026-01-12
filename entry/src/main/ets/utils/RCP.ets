import { rcp } from '@kit.RemoteCommunicationKit';
import { getBaseUrl } from '../utils/RCPConstants';

function sessionConfig(): rcp.SessionConfiguration {
  return {
    baseAddress: getBaseUrl()
  }
}

export function getHttp(url: string) {
  const session = rcp.createSession(sessionConfig());
  return session.get(`${url}`).then((res) => res.toJSON()).finally(() => {
    session.close();
  });
}