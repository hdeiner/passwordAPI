#!/usr/bin/env bash

echo Stop sqlsvrtest running in Docker container
sudo -S <<< "password" docker stop sqlsvrtest

echo Remove sqlsvrtest from Docker container
sudo -S <<< "password" docker rm sqlsvrtest