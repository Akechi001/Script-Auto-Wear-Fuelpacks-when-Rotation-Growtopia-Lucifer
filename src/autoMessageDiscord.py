import threading
import time
import requests
from dotenv import load_dotenv
import os

# Load token
load_dotenv()
token = os.getenv("DISCORD_BOT_TOKEN")

headers = {
    "Authorization": f"{token}",
    "Content-Type": "application/json"
}

# Matrix of message jobs
message_matrix = [
    {
        "content": "SELL HTB SEED 4/1\nHAVE TONS!\n\n\nGO PAKAKBAR <:pinkiesalute:947055428473348106>***",
        "url": "https://discord.com/api/v9/channels/1105154359114875072/messages",
        "delay": 5 * 60 * 60 + 300  # 6 jam 5 menit
    },
    {
        "content": "SELL HTB SEED 4/1\nHAVE TONS!\n\n\nGO PAKAKBAR <:pinkiesalute:947055428473348106>***",
        "url": "https://discord.com/api/v9/channels/846678373635457024/messages",
        "delay": 7 * 60 * 60 + 300  # 2 jam 5 menit
    },
]


# Worker function that keeps sending messages in a loop
def send_message_repeatedly(content, url, delay):
    while True:
        try:
            payload = { "content": content }
            res = requests.post(url, json=payload, headers=headers)
            print(f"[{time.strftime('%H:%M:%S')}] Sent to {url} | Status: {res.status_code} | Response: {res.text}")
        except Exception as e:
            print(f"Error sending to {url}: {e}")
        time.sleep(delay)

# Start a thread for each repeating message
for msg in message_matrix:
    t = threading.Thread(
        target=send_message_repeatedly,
        args=(msg["content"], msg["url"], msg["delay"]),
        daemon=True  # Optional: thread will close when main program exits
    )
    t.start()

# Keep main thread alive forever
print("Semua pesan akan dikirim berulang sesuai jadwal.")
while True:
    time.sleep(15)  # biar script utama tidak langsung selesai
