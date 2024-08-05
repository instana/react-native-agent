declare module "react-native" {
  export const NativeModules: {
    Instana: InstanaInterface;
  };
}

interface InstanaInterface {
  setup(key: string, reportingUrl: string, options?: SetupOption): void;
  setCollectionEnabled(enabled: ?boolean): void;
  setView(viewName: string): void;
  getSessionID(): Promise<string>;
  setUserID(userID: string): void;
  setUserName(userName: string): void;
  setUserEmail(userEmail: string): void;
  setMeta(key: string, value: string): void;
  setIgnoreURLsByRegex(regexArray: Array): Promise<any>;
  setRedactHTTPQueryByRegex(regexArray: Array): Promise<any>;
  setCaptureHeadersByRegex(regexArray: Array): Promise<any>;
  reportEvent(eventName: string, options?: EventOption): void;
}

interface SetupOption {
  collectionEnabled: boolean;
  enableCrashReporting: boolean;
  slowSendInterval: number;
  usiRefreshTimeIntervalInHrs: number;
}

interface EventOption {
  startTime?: number;
  duration?: number;
  viewName?: string;
  meta?: Map<any, any>;
  backendTracingId?: string;
  customMetric?: number;
}
