from locust.env import Environment
from pop_db import PopulateDatabase
from background_traffic import BackgroundTraffic

import time

if __name__=="__main__":
    # TODO get this automatically or pass it in
    host = 'http://192.168.49.2:30001'
    # env = Environment(user_classes=[PopulateDatabase], host=host)
    # env.create_local_runner()
    # env.runner.start(1, spawn_rate=20)
    # # Wait 10s
    # time.sleep(10)
    # env.runner.stop()

    env = Environment(user_classes=[BackgroundTraffic], host=host)
    env.create_local_runner()
    env.runner.start(20, spawn_rate=20)
    # Wait 120s
    time.sleep(120)
    env.runner.stop()