/*
 * (c) Copyright IBM Corp. 2021
 * (c) Copyright Instana Inc. and contributors 2021
 */

import React, { Component } from 'react';
import { StyleSheet, Text, View, SafeAreaView, Button } from 'react-native';
import { NativeModules } from 'react-native';
import Instana from '@instana/react-native-agent';
console.warn(Instana);
console.warn(NativeModules);

export default class App extends Component {
  componentDidMount() {
    Instana.setup('Prmco-4ZRq66pMIt2HPB5Q', 'https://eum-red-saas.instana.io/mobile');
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
        await Instana.setIgnoreURLsByRegex(["http:\/\/localhost:8081.*", "example.com", "["]);
      } catch (e) {
        console.warn(e);
      }
    }
  }


  async onRunFetchAsync() {
    try {
      let response = await fetch('https://reactnative.dev/movies.json');
      let json = await response.json()
      console.log('success', json);
    } catch (error) {
      console.warn(error);
    }
  }

  async onRunXMLHttpRequest() {
    var request = new XMLHttpRequest();
    request.onreadystatechange = (e) => {
      if (request.readyState !== 4) {
        return;
      }

      if (request.status === 200) {
        console.log('success', request.responseText);
      } else {
        console.warn('error');
      }
    };

    request.open('GET', 'https://reactnative.dev/movies.json');
    request.send();
  }

  async onSendCustomEvent() {
    var date = new Date();
    var epochMs = date.getTime();
    Instana.reportEvent("myCustomEvent", {
      startTime: epochMs-500,
      duration: 300,
      viewName: "overridenViewName",
      backendTracingId: "1234567890",
      meta: {
        keyOne: "value_one",
        keyTwo: "value_two",
      },
    });
  }

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <View>
        <Button
          onPress={this.onRunFetchAsync}
          title="Run `fetch`"
        />
        </View>
        <View  style={{marginTop:10}}>
        <Button
          onPress={this.onRunXMLHttpRequest}
          title="Run `XMLHttpRequest`"
        />
        </View>
        <View  style={{marginTop:10}}>
        <Button
          onPress={this.onSendCustomEvent}
          title="Send `CustomEvent`"
        />
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
  }
});
