#!/bin/bash
zramUse=$(cat /proc/swaps | grep zram | awk '{print $4}') && zramUse=$(($zramUse*1024)) && zramUse=$(printf %s\\n $zramUse| numfmt --to=iec-i)
zramTotal=$(cat /proc/swaps | grep zram | awk '{print $3}') && zramTotal=$(($zramTotal*1024)) && zramTotal=$(printf %s\\n $zramTotal| numfmt --to=iec-i)

echo $zramUse / $zramTotal
