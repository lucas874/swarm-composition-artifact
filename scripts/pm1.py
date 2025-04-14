from tqdm import tqdm
import os
import time
import sys
#$SHORT_ACCURACY_RESULT_DIR $num_files "Shortened accuracy test"
watch_dir = sys.argv[1]
total = int(sys.argv[2])  # Expected directories

for _ in tqdm(range(total), desc=sys.argv[3]):
    count = len([d for d in os.listdir(watch_dir) if os.path.isdir(os.path.join(watch_dir, d))])
    time.sleep(0.5)
    if count - 3 >= total:
        break