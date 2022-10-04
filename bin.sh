#! /bin/sh
array_prepare_for_picoscenes 1 "5240 HT40"
PicoScenes "-d debug --bp; -i 1 --freq 5240 --mode logger"
