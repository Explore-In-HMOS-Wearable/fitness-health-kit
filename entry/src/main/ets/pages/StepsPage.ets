import { StepsViewModel } from '../viewmodel/StepsViewModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { TokenResponse } from '../model/TokenResponse';
import { StepDataResult } from '../model/StepDataResult';

@Builder
export function StepsPageBuilder() {
  StepsPage()
}

@Entry
@Component
export struct StepsPage {
  @State stepList: number[] = []; // save steps here
  @State timesList: string[] = []; // save start and end times here
  @State isLoading: boolean = true;
  private viewModel = new StepsViewModel();
  @Consume('mainStack') pathStack: NavPathStack;
  token: TokenResponse = {
    accessToken: '',
    expiresIn: 0,
    idToken: '',
    refreshToken: '',
    scope: '',
    tokenType: ''
  }

  aboutToAppear(): void {
    this.token = this.pathStack.getParamByName('StepsPage')[0] as TokenResponse

    if (this.token) {
      console.info('Received token:', this.token.accessToken);
      this.viewModel.getSteps(this.token.accessToken)
        .then((result: StepDataResult) => {
          this.stepList = result.steps;
          this.timesList = result.times;
          this.isLoading = false;
          console.info(`Fetched steps: ${result.steps}, times: ${result.times}`);
        })
        .catch((e: BusinessError) => {
          console.error('Step fetch failed:', e);
          this.isLoading = false;
        });

    } else {
      console.error('No access token found.');
    }
  }

  build() {
    NavDestination() {
      Column() {
        if (this.isLoading) {
          Text($r('app.string.loading'))
            .fontSize(16);
        }
        else if (this.stepList.length === 0) {
          Text($r('app.string.no_step'))
            .fontSize(16);
        } else {
          List({ space: 2 }) {
            ForEach(this.stepList, (step: number, index: number) => {
              ListItem() {
                Column() {
                  Text(`Steps: ${step}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold);

                  // Show start time
                  if (this.timesList.length > index * 2) {
                    Text(`Start: ${this.timesList[index * 2]}`)
                      .fontSize(12)
                  }

                  // Show end time
                  if (this.timesList.length > index * 2 + 1) {
                    Text(`End: ${this.timesList[index * 2 + 1]}`)
                      .fontSize(12)
                  }
                }
                .padding(6)
              }
              .width('100%')
            }, (item: string, index: number) => item)
          }
          .width('100%')
          .height('100%')
        }
      }
      .margin({ top: 10, bottom: 30 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}