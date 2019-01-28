#!/bin/bash

# https://stackoverflow.com/questions/51650405/measure-execution-time-of-docker-container

START=$(docker inspect --format='{{.State.StartedAt}}' $1)
STOP=$(docker inspect --format='{{.State.FinishedAt}}' $1)

START_TIMESTAMP=$(date --date=$START +%s)
STOP_TIMESTAMP=$(date --date=$STOP +%s)

#echo $(($STOP_TIMESTAMP-$START_TIMESTAMP)) seconds

secs=$(($STOP_TIMESTAMP-$START_TIMESTAMP))
printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
