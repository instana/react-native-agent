import "react-native";

declare module "react-native" {
  interface NativeModulesStatic {
    Instana: InstanaInterface;
  }
}

interface InstanaInterface {
  setup(key: string, reportingUrl: string, options?: SetupOption): void;
  setCollectionEnabled(enabled?: boolean): void;
  setView(viewName: string): void;
  getSessionID(): Promise<string>;
  setUserID(userID: string): void;
  setUserName(userName: string): void;
  setUserEmail(userEmail: string): void;
  setMeta(key: string, value: string): void;
  setIgnoreURLsByRegex(regexArray: Array<any>): Promise<any>;
  setRedactHTTPQueryByRegex(regexArray: Array<any>): Promise<any>;
  setCaptureHeadersByRegex(regexArray: Array<any>): Promise<any>;
  reportEvent(eventName: string, options?: EventOption): void;
}

interface SetupOption {
  collectionEnabled: boolean;
  enableCrashReporting: boolean;
  slowSendInterval: number;
  usiRefreshTimeIntervalInHrs: number;
  httpCaptureConfig: any;
  suspendReporting: any;
  dropBeaconReporting: boolean;
  /**
   * Rate-Limiter configuration for the maximum number of beacons allowed within specific time intervals:
   *
   * - 0 (DEFAULT_LIMITS):
   *     - 500 beacons per 5 minutes
   *     - 20 beacons per 10 seconds
   *
   * - 1 (MID_LIMITS):
   *     - 1000 beacons per 5 minutes
   *     - 40 beacons per 10 seconds
   *
   * - 2 (MAX_LIMITS):
   *     - 2500 beacons per 5 minutes
   *     - 100 beacons per 10 seconds
   */
  rateLimits: any;
  enableW3CHeaders: boolean;
}

interface EventOption {
  startTime?: number;
  duration?: number;
  viewName?: string;
  meta?: Map<any, any>;
  backendTracingId?: string;
  customMetric?: number;
}
