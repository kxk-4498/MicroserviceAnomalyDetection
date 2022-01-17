import base64

from locust import HttpUser, task
from random import randint, choice
#import random
import string
import pickle
import time
import os

import sockshop_api

# this way we can simulate users using already-existing accounts
with open( "users.pickle", "rb" ) as f:
    users = pickle.loads( f.read() )

if os.path.isfile('prob_distro_sock.pickle'):
    with open('prob_distro_sock.pickle', 'r') as f:
        prob_distr = pickle.loads(f.read())
else:
    ## here's a hypothetical default probability distribution...
    #prob_distr = {'buy': 0.3, 'browse': 0.5, 'register': 0.2}
    prob_distr = {'buy': 0.0, 'browse': 1.0, 'register': 0.0}

num_browsing = 21
min_wait = 2000
max_wait = 4000

class BackgroundTraffic(HttpUser):
    #'''
    # the way I wrote this script, these are really the times between new users showing up
    min_wait = 2000
    max_wait = 4000

    ## note: assuming visitor will only login if they mean to buy osmething...
    @task(int(prob_distr['buy'] * 100))
    def buy(self):
        self.client.get("/")
        # first login
        user = choice(users)
        # NOTE: this borrows code from weave's load-test repo
        sockshop_api.login(self.client, user, user)
        time.sleep(randint(min_wait, max_wait) / 1000.0)  # going to wait a bit between events

        catalogue = self.client.get("/catalogue").json()
        time.sleep(randint(min_wait,max_wait) / 1000.0) # going to wait a bit between events
        category_item = choice(catalogue)
        item_id = category_item["id"]
        self.client.get("/category.html")
        time.sleep(randint(min_wait,max_wait) / 1000.0) # going to wait a bit between events
        self.client.get("/detail.html?id={}".format(item_id))

        time.sleep(randint(min_wait, max_wait) / 1000.0)  # going to wait a bit between events
        # NOTE: this borrows code from weave's load-test repo
        self.client.delete("/cart")
        item_num = 1  # randint(1,4) # can't be more than 100 and they have something that is 99.99
        self.client.post("/cart", json={"id": item_id, "quantity": item_num})
        time.sleep(randint(min_wait, max_wait) / 1000.0)  # going to wait a bit between events
        self.client.get("/basket.html")
        order_post = self.client.post("/orders")

    @task(int(prob_distr['browse'] * 100))
    def browse(self):
        self.client.get("/")
        catalogue = self.client.get("/catalogue").json()
        for i in range(1, num_browsing):
            time.sleep(randint(min_wait,max_wait) / 1000.0) # going to wait a bit between events
            category_item = choice(catalogue)
            item_id = category_item["id"]
            self.client.get("/category.html")
            time.sleep(randint(min_wait,max_wait) / 1000.0) # going to wait a bit between events
            self.client.get("/detail.html?id={}".format(item_id))

    @task(int(prob_distr['register'] * 100))
    def register(self):
        self.client.get("/")
        sockshop_api.register(self.client)
