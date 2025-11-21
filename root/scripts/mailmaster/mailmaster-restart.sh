#!/bin/bash
pkill -9 -f /opt/mailmaster/mailmaster 2>/dev/null
nohup /opt/mailmaster/mailmaster >/dev/null 2>&1 &
