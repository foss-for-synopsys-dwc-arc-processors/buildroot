#!/bin/sh
# Required for Qt input to work
# If running interactively
export QWS_KEYBOARD=linuxinput:/dev/input/event1
export QWS_MOUSE_PROTO=tslib:/dev/input/event0

