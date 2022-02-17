import argparse

from locust.env import Environment
from pop_db import PopulateDatabase

import time

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', dest='populate_db', action='store_true', help='Populate Database')
    parser.add_argument('-t', dest='sim_traffic', action='store_true', help='Simulate Traffic')
    parser.set_defaults(populate_db=False)
    parser.set_defaults(sim_traffic=False)
    args = parser.parse_args()

    # TODO get this automatically or pass it in
    host = 'http://192.168.49.2:30004'

    if args.populate_db:
        print('Populating DB...')
        env = Environment(user_classes=[PopulateDatabase], host=host)
        env.create_local_runner()
        env.runner.start(1, spawn_rate=20)
        # Wait 10s
        time.sleep(10)
        env.runner.stop()

    if args.sim_traffic:
        from background_traffic import BackgroundTraffic
        print('Simulating Traffic...')
        env = Environment(user_classes=[BackgroundTraffic], host=host)
        env.create_local_runner()
        env.runner.start(20, spawn_rate=20)
        # Wait 120s
        time.sleep(120)
        env.runner.stop()
