import 'react-native';

declare module 'react-native' {
  export interface NativeModules {
    Instana: InstanaInterface;
  }
}

/**
 * HTTP capture configuration options
 */
export type HTTPCaptureConfig = 'AUTO' | 'NONE';

/**
 * Suspend reporting configuration (Android only)
 * iOS always uses false for both battery and cellular suspension
 */
export type SuspendReportingType =
  | 'NEVER'
  | 'LOW_BATTERY'
  | 'CELLULAR_CONNECTION'
  | 'LOW_BATTERY_OR_CELLULAR_CONNECTION';

/**
 * Rate limits configuration for beacon transmission
 */
export enum RateLimits {
  /** 500 beacons per 5 minutes, 20 beacons per 10 seconds */
  DEFAULT_LIMITS = 0,
  /** 1000 beacons per 5 minutes, 40 beacons per 10 seconds */
  MID_LIMITS = 1,
  /** 2500 beacons per 5 minutes, 100 beacons per 10 seconds */
  MAX_LIMITS = 2,
}

export interface InstanaInterface {
  /**
   * Initialize Instana monitoring with configuration options
   * Note: options parameter is required by the native implementation
   */
  setup(key: string, reportingUrl: string, options: SetupOptions): void;

  /**
   * Enable or disable data collection
   */
  setCollectionEnabled(enabled?: boolean): void;

  /**
   * Set the current view name for tracking
   */
  setView(viewName: string): void;

  /**
   * Get the current session ID
   */
  getSessionID(): Promise<string>;

  /**
   * Set the user ID for tracking
   */
  setUserID(userID: string): void;

  /**
   * Set the user name for tracking
   */
  setUserName(userName: string): void;

  /**
   * Set the user email for tracking
   */
  setUserEmail(userEmail: string): void;

  /**
   * Set custom metadata key-value pairs
   */
  setMeta(key: string, value: string): void;

  /**
   * Set regex patterns for URLs to ignore
   * @param regexArray Array of regex pattern strings
   * @returns Promise that resolves to "Success" or rejects with error
   */
  setIgnoreURLsByRegex(regexArray: string[]): Promise<string>;

  /**
   * Set regex patterns for HTTP query parameters to redact
   * @param regexArray Array of regex pattern strings
   * @returns Promise that resolves to "Success" or rejects with error
   */
  setRedactHTTPQueryByRegex(regexArray: string[]): Promise<string>;

  /**
   * Set regex patterns for HTTP headers to capture
   * @param regexArray Array of regex pattern strings
   * @returns Promise that resolves to "Success" or rejects with error
   */
  setCaptureHeadersByRegex(regexArray: string[]): Promise<string>;

  /**
   * Report a custom event with optional metadata
   */
  reportEvent(eventName: string, options?: EventOptions): void;

  /**
   * Get the current view name (iOS only)
   */
  getViewName?(): Promise<string>;

  /**
   * Get whether collection is enabled (iOS only)
   */
  getCollectionEnabled?(): Promise<boolean>;
}

export interface SetupOptions {
  /**
   * Enable or disable data collection on startup
   * @default true
   */
  collectionEnabled?: boolean;

  /**
   * Enable or disable crash reporting
   * @default false
   */
  enableCrashReporting?: boolean;

  /**
   * Slow sending interval in seconds (0.0 to disable)
   * Range: 2-3600 seconds
   * @default 0.0
   */
  slowSendInterval?: number;

  /**
   * User session ID refresh interval in hours
   * - Negative value: Never refresh (default)
   * - Positive value: Refresh at specified interval
   * - Zero: Disable user session ID
   * @default -1.0
   */
  usiRefreshTimeIntervalInHrs?: number;

  /**
   * HTTP capture configuration
   * @default 'AUTO'
   */
  httpCaptureConfig?: HTTPCaptureConfig;

  /**
   * Suspend reporting configuration (Android only)
   * iOS ignores this and always uses false for battery/cellular suspension
   * @default 'LOW_BATTERY' on Android
   */
  suspendReporting?: SuspendReportingType;

  /**
   * Enable reporting of dropped beacons when rate limits are exceeded
   * @default false
   */
  dropBeaconReporting?: boolean;

  /**
   * Rate limits for beacon transmission
   * @default RateLimits.DEFAULT_LIMITS (0)
   */
  rateLimits?: RateLimits | number;

  /**
   * Trust device timing for beacon timestamps instead of server receipt time
   * @default false
   */
  trustDeviceTiming?: boolean;

  /**
   * Include W3C trace headers (traceparent and tracestate) for backend correlation
   * @default false
   */
  enableW3CHeaders?: boolean;

  /**
   * List of domain patterns to track query parameters (mobile-specific)
   * Not commonly used in React Native
   */
  queryTrackedDomainList?: string[];
}

export interface EventOptions {
  /**
   * Event start timestamp in milliseconds
   */
  startTime?: number;

  /**
   * Event duration in milliseconds
   */
  duration?: number;

  /**
   * View name associated with the event
   */
  viewName?: string;

  /**
   * Custom metadata for the event
   * Note: Should be a plain object, not a Map
   */
  meta?: Record<string, string>;

  /**
   * Backend tracing ID for correlation
   */
  backendTracingId?: string;

  /**
   * Custom metric value (double/float)
   */
  customMetric?: number;
}

/**
 * Default export - the main Instana instance
 */
declare const Instana: InstanaInterface;
export default Instana;

/**
 * Type alias for the main interface
 */
export type InstanaAgent = InstanaInterface;
