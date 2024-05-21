#!/bin/bash
sleep 5
killpid="$(pidof Aki.Server.exe)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof tail)"
exit 0
done