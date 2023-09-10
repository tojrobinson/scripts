import os
import subprocess
import time
import re
from datetime import datetime
import pytz

eastern = pytz.timezone('US/Eastern')

TIME_LIMIT = 600 # 10 mminutes
last_sizes = {}

while True:
    forever_list = subprocess.getoutput("forever list --plain")
    pattern = re.compile(r" (\d+)\s+(/\w+.*\.log)")
    curr_time = datetime.now(eastern).strftime("%I:%M:%S %p")
    
    print(f"[{curr_time}]")
    for line in forever_list.strip().split('\n')[5:]:
        match = pattern.search(line)

        if match:
            pid = match.group(1)
            log_file = match.group(2)

            if not os.path.exists(log_file):
                print(f"Log file {log_file} does not exist.")
                continue

            current_size = os.path.getsize(log_file)
            last_size = last_sizes.get(log_file, None)

            print(f"{pid}: {last_size} -> {current_size}")

            if current_size != last_size:
                last_sizes[log_file] = current_size
                print(f"Log file {log_file} is up to date.")
            else:
                print(f"Log file {log_file} has not been updated in {TIME_LIMIT} seconds. Restarting {pid}.")
                subprocess.run(["forever", "restart", pid])
    print('---')
    time.sleep(TIME_LIMIT)
