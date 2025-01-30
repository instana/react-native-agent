import  "../index.js";

import { NativeModules } from "react-native";

const { Instana } = NativeModules;
jest.mock('react-native', () => ({
    NativeModules: {
        Instana: {
            setup: jest.fn(),
            setCollectionEnabled: jest.fn(),
            setView: jest.fn(),
            getSessionID: jest.fn().mockResolvedValue('mockSessionId'),
            setUserID: jest.fn(),
            setUserName: jest.fn(),
            setUserEmail: jest.fn(),
            setMeta: jest.fn(),
            setIgnoreURLsByRegex: jest.fn().mockResolvedValue(true),
            setRedactHTTPQueryByRegex: jest.fn().mockResolvedValue(true),
            setCaptureHeadersByRegex: jest.fn().mockResolvedValue(true),
            reportEvent: jest.fn()
        },
    },
}));

describe('Call Instana APIs', () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    test('call setup function', () => {
        const key = 'testkey';
        const url = 'https://reportingUrl.com';
        const collectionEnabled = false;
        const suspendReporting = 'LOW_BATTERY_OR_CELLULAR_CONNECTION'
        Instana.setup(key, url, {collectionEnabled,suspendReporting});
        expect(NativeModules.Instana.setup).toHaveBeenCalledWith(key, url, {collectionEnabled,suspendReporting});
    });

    test('call setView function', () => {
        const viewName = 'FirstView';
        Instana.setView(viewName);
        expect(NativeModules.Instana.setView).toHaveBeenCalledWith(viewName);
    });

    test('call getSession  ID function', async () => {
        const sessionID = await Instana.getSessionID();
        expect(sessionID).toBe('mockSessionId');
    });

    test('call userID function', () => {
        const userID = 'firstID';
        Instana.setUserID(userID);
        expect(NativeModules.Instana.setUserID).toHaveBeenCalledWith(userID);
    });

    test('call useName function', () => {
        const userName = 'firstUser';
        Instana.setUserName(userName);
        expect(NativeModules.Instana.setUserName).toHaveBeenCalledWith(userName);
    });

    test('call useEmail function', () => {
        const userEmail = 'firstUserEmail';
        Instana.setUserEmail(userEmail);
        expect(NativeModules.Instana.setUserEmail).toHaveBeenCalledWith(userEmail);
    });

    test('calling meta function', () => {
        const key = 'setMetaKey';
        const value = 'setMetaValue';
        Instana.setMeta(key, value);
        expect(NativeModules.Instana.setMeta).toHaveBeenCalledWith(key, value);
    });

    test('set to ignore url', async () => {
        const arrayToIgnore = 'http:\/\/localhost:8081.*';
        const ignoreUrlByRegex = await Instana.setIgnoreURLsByRegex([arrayToIgnore]);
        expect(ignoreUrlByRegex).toBe(true);
    });

    test('set to redact url', async () => {
        const arrayToRedact = 'pass(word|wort)';
        const redactUrlByRegex = await Instana.setRedactHTTPQueryByRegex([arrayToRedact]);
        expect(redactUrlByRegex).toBe(true);
    });

    test('set to capture header', async () => {
        const captureHeader = 'cache-control';
        const captureHeaderByRegex = await Instana.setCaptureHeadersByRegex([captureHeader]);
        expect(captureHeaderByRegex).toBe(true);
    });

    test('set to report events', async () => {
        const eventName = 'First view';
        Instana.reportEvent(eventName);
        expect(NativeModules.Instana.reportEvent).toHaveBeenCalledWith(eventName);
    });

});


    
    
    
