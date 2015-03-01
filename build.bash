#!/bin/bash
docker rm -f smaccmpilot
docker build -t oleg/smaccmpilot .
