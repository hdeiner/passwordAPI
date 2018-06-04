#!/usr/bin/env bash

sudo -S <<< "password" docker stop passwordAPI
sudo -S <<< "password" docker rm passwordAPI