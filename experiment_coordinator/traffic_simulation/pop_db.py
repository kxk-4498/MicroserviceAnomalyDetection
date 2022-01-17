import base64

from locust import HttpUser, task

# from random import randint, choice
import random
import string
import pickle

import sockshop_api

users = []

class PopulateDatabase(HttpUser):
    # we don't need "long" wait times here to simulate user delay,
    # we just want stuff in the DB
    min_wait = 100
    max_wait = 101

    # first register a user than register a credit card for that user (after login)
    @task
    def populate_data(self):
        username, password = sockshop_api.register(self.client)
        users.append(username)

        pickle.dump(users, open("users.pickle", "wb"))