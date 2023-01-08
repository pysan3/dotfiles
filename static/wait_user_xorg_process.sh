#!/usr/bin/env bash

process_name="${1:-Xorg}"

while ! pgrep -U "$USER" "$process_name"; do
  sleep 2
done

sleep 10
