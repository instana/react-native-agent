/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import {Button, SafeAreaView, StyleSheet, View} from 'react-native';
import React, {Component} from 'react';

import Instana from '@instana/react-native-agent';

class App extends Component {
  componentDidMount() {
    var options = {};
    //    options.usiRefreshTimeIntervalInHrs = 24.0;
    options.suspendReporting =
      Instana.androidSuspendReport.LOW_BATTERY_OR_CELLULAR_CONNECTION;
    Instana.setup('<your key>', '<your reporting url>', options);
    Instana.setUserID('123456');
    Instana.setUserEmail('nils@example.com');
    Instana.setUserName('Nils Mustermann');
    Instana.setMeta('randomKey', 'randomValue');
    Instana.setView('MainView');

    getSessionID();
    async function getSessionID() {
      try {
        var sessionID = await Instana.getSessionID();
      } catch (e) {
        console.error(e);
      }
    }

    setIgnoreURLsByRegex();
    async function setIgnoreURLsByRegex() {
      try {
        await Instana.setIgnoreURLsByRegex([
          'http://localhost:8081.*',
          'example.com',
        ]);
      } catch (e) {
        console.warn(e);
      }
    }

    setRedactHTTPQueryByRegex();
    async function setRedactHTTPQueryByRegex() {
      try {
        await Instana.setRedactHTTPQueryByRegex(['key', 'passwor[td]']);
      } catch (e) {
        console.warn(e);
      }
    }

    setCaptureHeadersByRegex();
    async function setCaptureHeadersByRegex() {
      try {
        await Instana.setCaptureHeadersByRegex(['cache-control', 'etag']);
      } catch (e) {
        console.warn(e);
      }
    }
  }

  async onRunFetchAsync() {
    try {
      let response = await fetch('https://reactnative.dev/movies.json');
      let json = await response.json();
      console.log('success', json);
    } catch (error) {
      console.warn(error);
    }
  }

  async onRunXMLHttpRequest() {
    Instana.setCollectionEnabled(true);
    var request = new XMLHttpRequest();
    request.onreadystatechange = e => {
      if (request.readyState !== 4) {
        return;
      }

      if (request.status === 200) {
        console.log('success', request.responseText);
      } else {
        console.warn('error');
      }
    };

    request.open(
      'GET',
      'https://reactnative.dev/movies.json?password=sec&key=sec',
    );
    request.send();
  }

  async onSendCustomEvent() {
    Instana.reportEvent('simpleCustomEvent', null);

    var date = new Date();
    var epochMs = date.getTime();
    Instana.reportEvent('myCustomEvent', {
      startTime: epochMs - 500,
      duration: 300,
      viewName: 'overridenViewName',
      backendTracingId: '1234567890',
      meta: {
        keyOne: 'value_one',
        keyTwo: 'value_two',
      },
      customMetric: 987.654321,
    });
  }

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <View>
          <Button onPress={this.onRunFetchAsync} title="Run `fetch`" />
        </View>
        <View style={{marginTop: 10}}>
          <Button
            onPress={this.onRunXMLHttpRequest}
            title="Run `XMLHttpRequest`"
          />
        </View>
        <View style={{marginTop: 10}}>
          <Button onPress={this.onSendCustomEvent} title="Send `CustomEvent`" />
        </View>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});

export default App;
