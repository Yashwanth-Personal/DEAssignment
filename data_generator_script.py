# data-generator/generator.py
import os
import time
import random
import csv
from datetime import datetime
from multiprocessing import Process

SFTP_PATH = "/data/sftp/incoming"
ROW_SIZE = 300  # approx bytes
MBPS = 84
BYTES_PER_SEC = MBPS * 1024 * 1024
ROWS_PER_SEC = BYTES_PER_SEC // ROW_SIZE
DURATION = 75  # seconds per file


def generate_file():
    while True:
        ts = datetime.now().strftime('%Y%m%d_%H%M%S')
        file_name = f"cdr_{ts}.csv"
        file_path = os.path.join(SFTP_PATH, file_name)
        with open(file_path, mode='w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(["user_id", "type", "status", "event_time"])
            for _ in range(int(ROWS_PER_SEC * DURATION)):
                writer.writerow([
                    random.randint(1000, 9999),
                    random.choice(["VOICE", "SMS", "DATA"]),
                    random.choice(["ACTIVE", "INACTIVE"]),
                    datetime.utcnow().isoformat()
                ])
        print(f"[Generator] Dropped file: {file_name}")
        time.sleep(DURATION)


if __name__ == "__main__":
    workers = 3  # Parallelism of 3 nodes
    for _ in range(workers):
        Process(target=generate_file).start()
