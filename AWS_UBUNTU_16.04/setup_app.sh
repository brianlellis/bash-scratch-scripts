#!/bin/bash

sudo yarn install;
npm install pm2 -g;
pm2 start server.js --watch;