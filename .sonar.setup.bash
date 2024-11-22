#!/usr/bin/env bash

export runDev=true
apt update

yarn install
yarn run test
