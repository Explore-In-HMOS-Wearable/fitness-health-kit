import preferences from '@ohos.data.preferences';

const PREFERENCES_NAME = 'settings.db';
let settingsPreferences: preferences.Preferences | null = null;

@Observed
export default class Preferences {
  static instance = new Preferences();
  private uiContext?: UIContext;

  constructor() {
    this.initialize();
  }

  async initialize() {
    await this.getPreferencesFromStorage();
  }

  async getPreferencesFromStorage() {
    const context = this.uiContext?.getHostContext() as Context;
    settingsPreferences = await preferences.getPreferences(context, PREFERENCES_NAME);
  }

  async on(callback: Callback<Record<string, preferences.ValueType>>) {
    settingsPreferences?.on('dataChange', ['settings'], callback);
  }

  async off() {
    settingsPreferences?.off('dataChange', ['settings']);
  }

  putPreference(key: string, value: string) {
    if (settingsPreferences !== null) {
      settingsPreferences.putSync(key, value);
      settingsPreferences.flush();
    }
  }

  getPreference(key: string): string {
    let value: string = '';
    if (settingsPreferences !== null) {
      value = settingsPreferences.getSync(key, '') as string;
    }
    return value;
  }
}
