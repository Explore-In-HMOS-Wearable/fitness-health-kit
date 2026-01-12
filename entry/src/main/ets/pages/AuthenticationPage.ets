import { AuthenticationViewModel } from '../viewmodel/AuthenticationViewModel';
import { APIConstants } from '../common/Constants';
import { webview } from '@kit.ArkWeb';
import { ButtonComponent } from '../component/ButtonComponent';
import { BusinessError } from '@kit.BasicServicesKit';
import { TokenResponse } from '../model/TokenResponse';

@Builder
export function AuthenticationPageBuilder() {
  Authentication()
}

@Entry
@Component
export struct Authentication {
  @State shouldShowWebView: boolean = true;
  @State accessToken: string = '';
  @State activationKey: string = '';
  controller: webview.WebviewController = new webview.WebviewController();
  private viewModel = new AuthenticationViewModel();
  @Consume('mainStack') pathStack: NavPathStack;

  aboutToAppear(): void {
    const storedToken = this.viewModel.getAccessTokenFromStorage();
    if (storedToken.length > 0) {
      this.accessToken = storedToken;
      this.shouldShowWebView = false;
    }
  }

  handleOAuthCode(code: string) {
    this.activationKey = code;
    this.shouldShowWebView = false;

    this.viewModel.postOAuthToken(code).then((token) => {
      if (token) {
        this.accessToken = token;
      }
    }).catch((e: BusinessError) => {
      console.error('Token exchange failed:', e);
    });
  }

  build() {
    NavDestination() {
      Column() {
        if (this.shouldShowWebView) {
          Web({ src: APIConstants.AUTH_URL, controller: this.controller })
            .width('100%')
            .height('100%')
            .onLoadIntercept((event) => {
              if (event) {
                const url = event.data.getRequestUrl();
                console.info(`URL: ${url}`);
                const code = this.viewModel.getQueryParameter(url, 'code');
                if (code) {
                  console.info(`Code received from redirect: ${code}`);
                  this.handleOAuthCode(code);
                }
              }
              return false;
            });
        } else {
          Column() {
            Text($r('app.string.access_token'))
              .fontSize(12)
              .height('20%')
              .width('100%')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center);

            Text(this.accessToken)
              .fontSize(12)
              .height('30%')
              .width('100%')
              .fontColor(Color.Red);

            ButtonComponent({ text: $r('app.string.continue') })
              .margin({ bottom: 5 })
              .onClick(() => {
                this.pathStack.pushPathByName('HomePage', null)
              });

            ButtonComponent({ text: $r('app.string.steps') })
              .margin({ bottom: 5 })
              .onClick(() => {
                this.pathStack.pushPath({
                  name: 'StepsPage',
                  param: { accessToken: this.accessToken } as TokenResponse
                })
              });
          }
          .height('100%')
          .width('100%');
        }
      }
      .height('100%')
      .width('100%');
    }
    .hideBackButton(true)
  }
}