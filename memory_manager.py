#!/usr/bin/env python

import psutil
import os
import time

count = 0
memory_threshold = 90;
breach_times = 3
interval_seconds = 20
process_match = ''

while True:
    # Get the percentage of used memory
    memory_info = psutil.virtual_memory()
    used_memory_percent = memory_info.percent
    norm_percent = int(used_memory_percent/2);

    memory_bar = ['[', *['|'] * norm_percent, *[' '] * (50 - norm_percent), ']']
    memory_bar[int(memory_threshold/2)] = '^'
    print(''.join(memory_bar))

    if used_memory_percent >= memory_threshold:
        count = count + 1

        print('Memory usage has been >', memory_threshold, '%', count, '/', breach_times, 'times')
        if count >= breach_times:
            print('Consitently above', memory_threshold, '%. Killing.')
            os.system(f'pkill -f "{process_match}"')
    else:
        count = 0

    # Sleep for 10 seconds before checking again
    time.sleep(interval_seconds)
