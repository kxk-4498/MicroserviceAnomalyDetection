# Helper functions to interact with Sock Shop API
import base64
import random
import string

def gen_random_str():
    username = ''
    for i in range(0, 10):
        username += random.choice(string.ascii_lowercase)
    return username

def get_random_num(num):
    cc_num = ''
    for i in range(0, num):
        cc_num += random.choice(string.digits)
    return cc_num

# Login
def login(client, username, password):
    username_encode = base64.b64encode(username.encode('ascii'))
    pass_encode = base64.b64encode(password.encode('ascii'))
    auth_str = f'Basic {username_encode}:{pass_encode}'
    return client.get("/login", headers={"Authorization": auth_str})

def register(client):
    # first register
    username = gen_random_str()
    password = username

    firstname = username + "ZZ"
    lastname = username + "QQ"
    email = username + "@gmail.com"

    # Register
    registerObject = {"username": username, "password": password, firstname: "HowdyG", "lastName": lastname,
                      "email": email}
    userID = client.post("/register", json=registerObject).text

    # Login
    login(client, username, password)

    # Register a credit card
    cc_num = get_random_num(16)
    expir_date = "11/2020"  # let's give everything the same expir_date b/c why not?
    ccv = get_random_num(3)
    creditCardObject = {"longNum": cc_num, "expires": expir_date, "ccv": ccv, "userID": userID}
    client.post("/cards", json=creditCardObject)

    # Add address to account so we can buy stuff
    addressObject = {"street": "Whitelees Road", "number": "246", "country": "United Kingdom", "city": "Glasgow",
                     "postcode": "G67 3DL", "id": userID}
    client.post("/addresses", json=addressObject)

    return username, password