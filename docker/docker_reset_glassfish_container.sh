#!/usr/bin/env bash


echo Stop glassfish running in Docker container
sudo -S <<< "password" docker stop glassfish

echo Remove glassfish from Docker container
sudo -S <<< "password" docker rm glassfish