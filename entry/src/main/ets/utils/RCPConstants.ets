import common from '@ohos.app.ability.common';

class ContextManager {
  private static ctx: common.UIAbilityContext;

  static setContext(context: common.UIAbilityContext): void {
    ContextManager.ctx = context;
  }

  static getUIAbilityContext(): common.UIAbilityContext {
    return ContextManager.ctx;
  }
}

export { ContextManager };

export function getBaseUrl(): string {
  return `https://${ContextManager.getUIAbilityContext().resourceManager.getStringSync($r('app.string.baseurl').id)}`;
}

export function getUrl(): string {
  return `https://${ContextManager.getUIAbilityContext().resourceManager.getStringSync($r('app.string.url').id)}`;
}

export function getSampleSet(): string {
  return `https://${ContextManager.getUIAbilityContext().resourceManager.getStringSync($r('app.string.sampleSet').id)}`;
}

export function getAuthUrl(): string {
  return `https://${ContextManager.getUIAbilityContext().resourceManager.getStringSync($r('app.string.authurl').id)}`;
}