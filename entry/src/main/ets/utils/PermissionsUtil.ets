import { abilityAccessCtrl, Context, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

class PermissionsUtil {
  requestPermissions(permissions: Array<Permissions>, context: Context): void {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, permissions)
      .then((data: PermissionRequestResult) => {
        hilog.info(0x0000, '', 'request Permissions success')
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, '',
          `Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
      })
  }
}

export default new PermissionsUtil();