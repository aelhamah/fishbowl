from django.shortcuts import render

# Create your views here.
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import JsonResponse, HttpResponse, response
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from google.oauth2 import id_token
from google.auth.transport import requests

import hashlib

# sender is an email address
# receivers are id_tokens of users
def getusers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    users_id_raw = request.GET.getlist('user_ids')
    users_id = []
    for u_id in users_id_raw:
        u_split = u_id.split(',')
        users_id += u_split 
    response = {}
    response['users'] = {}
    
    # return JsonResponse(response)
    cursor = connection.cursor()

    # get mappings from fishbowlIDs to emails
    cursor.execute('SELECT fishbowlID, email FROM fishes;')
    rows = cursor.fetchall()
    fish_id_to_email = {}
    for row in rows:
        fish_id_to_email[row[0].strip()] = row[1]

    # make sure that each user id is not blocked by the sender
    cursor.execute('SELECT * FROM blocks WHERE sender = %s;', (request.GET.get('sender'),))
    rows = cursor.fetchall()
    do_not_show = []
    for row in rows:
        do_not_show.append(row[1])

    cursor.execute('SELECT * FROM blocks WHERE receiver = %s;', (request.GET.get('sender'),))
    rows = cursor.fetchall()
    for row in rows:
        do_not_show.append(row[0])

    if users_id is None:
        return JsonResponse(response)

    # get sender's pereferences from users
    cursor.execute('SELECT gender_preference, relationship_preference, gender_identity FROM users WHERE email = %s;', (request.GET.get('sender'),))
    row = cursor.fetchone()
    gender_pref = row[0]
    relation_pref = row[1]
    gender_identity = row[2]
    
    if request.GET.get('sender') == "DojaEmail":
        do_not_show = []

    for user_id in users_id:
        # check if it is in do not show or exists at all
        if user_id not in fish_id_to_email or fish_id_to_email[user_id] in do_not_show :
            continue

        user_email = fish_id_to_email[user_id]
        cursor.execute("SELECT * FROM users WHERE email = '{}';".format(user_email))
        rows = cursor.fetchall()

        user_block = {
            cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))
        }
        #replace https with http
        if user_block['imageurl'] is not None:
            user_block['imageurl'] = user_block['imageurl'].replace('https', 'http')
        user_block['token'] = user_id

        # if the gender_identity and relationship_preference match add them
        if user_block['gender_identity'] == gender_pref \
            and user_block['relationship_preference'] == relation_pref \
                and user_block['gender_preference'] == gender_identity: 
            response['users'][user_id] = user_block
        
        elif request.GET.get('sender') == "DojaEmail":
            response['users'][user_id] = user_block

    return JsonResponse(response)

def is_mutual_like(sender, receiver):
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM matches WHERE sender = %s AND receiver = %s;', (sender, receiver))
    rows = cursor.fetchall()
    if len(rows) == 0:
        return False

    cursor.execute('SELECT * FROM matches WHERE sender = %s AND receiver = %s;', (receiver, sender))
    rows = cursor.fetchall()
    if len(rows) == 0:
        return False

    return True

@csrf_exempt
def postlikes(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    sender = json_data['sender']
    receiver = json_data['receiver']

    cursor = connection.cursor()
    cursor.execute('INSERT INTO matches (sender, receiver) VALUES (%s,%s);',(str(sender), str(receiver)))
    
    response = {}
    if is_mutual_like(sender, receiver):
        response['status'] = 'matched'
    else:
        response['status'] = 'unmatched'
    
    return JsonResponse(response)

@csrf_exempt
def createusers(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    email = request.POST.get("email")
    cursor = connection.cursor()

    # Do not modify if doja email
    if email == "DojaEmail":
        cursor.execute('SELECT * FROM users WHERE email = %s;', (email,))
        rows = cursor.fetchall()
        response = {cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))}
        return JsonResponse(response)

    # check if user exists
    cursor.execute('SELECT * FROM users WHERE email = %s;', (email,))
    rows = cursor.fetchall()
    username = request.POST.get("username")
    fullname = request.POST.get("fullname")
    display_name = request.POST.get("display_name")
    bio = request.POST.get("bio")
    gender_preference = request.POST.get("gender_preference")
    relationship_preference = request.POST.get("relationship_preference")
    gender_identity = request.POST.get("gender_identity")

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = email+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)
        # change from http to https
        imageurl = imageurl.replace("http://", "https://")
    else:
        imageurl = None

    if rows:
        # Update the database accordingly
        if username is not None:
            cursor.execute('UPDATE users SET username = %s WHERE email = %s;', (username, email)) 
        if fullname is not None:
            cursor.execute('UPDATE users SET display_name = %s WHERE email = %s;', (display_name, email))
        if bio is not None:
            cursor.execute('UPDATE users SET bio = %s WHERE email = %s;', (bio, email))
        if gender_preference is not None:
            cursor.execute('UPDATE users SET gender_preference = %s WHERE email = %s;', (gender_preference, email))
        if relationship_preference is not None:
            cursor.execute('UPDATE users SET relationship_preference = %s WHERE email = %s;', (relationship_preference, email))
        if gender_identity is not None:
            cursor.execute('UPDATE users SET gender_identity = %s WHERE email = %s;',(gender_identity, email))
        if imageurl is not None:
            cursor.execute('UPDATE users SET imageurl = %s WHERE email = %s;',(imageurl, email))

    else:
        cursor.execute('INSERT INTO users (display_name, email, bio, imageurl, gender_preference, relationship_preference, gender_identity) VALUES '
            '(%s,%s,%s,%s,%s,%s,%s,%s,%s) ON CONFLICT (email) DO NOTHING;', (display_name,email,bio,imageurl,gender_preference,relationship_preference,gender_identity))
    
    cursor.execute('SELECT * FROM users WHERE email = %s;', (email,))
    rows = cursor.fetchall()
    
    response = {cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))}
    return JsonResponse(response)

def getmatches(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    sender = request.GET.get('sender')
    response = {}
    response["matches"] = []
    cursor = connection.cursor()
    if sender is None:
        return JsonResponse(response)
    cursor.execute('SELECT * FROM matches WHERE sender = %s;', (sender,))
    rows = cursor.fetchall()
    
    users_id = []
    for row in rows:
        users_id.append(row[1])

    if users_id is None:
        return JsonResponse(response)

    # Only get stuff that user matches on (I am <sender> and looking for <receiver>)

   # return JsonResponse(response)
    for user_id in users_id:

        if not is_mutual_like(sender, user_id):
            continue

        cursor.execute("SELECT * FROM users WHERE email = %s;", (user_id,))
        rows = cursor.fetchall()

        if len(rows) == 0:
            continue
        response["matches"].append({
            cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))
        })
        # response[user_id] = {cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))}

    return JsonResponse(response,)

@csrf_exempt
def adduser(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    clientID = json_data['clientID']   # the front end app's OAuth 2.0 Client ID
    idToken = json_data['idToken']     # user's OpenID ID Token, a JSon Web Token (JWT)
    now = time.time()                  # secs since epoch (1/1/70, 00:00:00 UTC)

    try:
        # Collect user info from the Google idToken, verify_oauth2_token checks
        # the integrity of idToken and throws a "ValueError" if idToken or
        # clientID is corrupted or if user has been disconnected from Google
        # OAuth (requiring user to log back in to Google).
        # idToken has a lifetime of about 1 hour
        idinfo = id_token.verify_oauth2_token(idToken, requests.Request(), clientID)
        email = idinfo['email']
    except ValueError:
        # Invalid or expired token
        return HttpResponse(status=511)  # 511 Network Authentication Required

    # get username
    try:
        username = idinfo['name']
    except:
        username = "Profile NA"

    # Compute chatterID and add to database
    backendSecret = "giveamouseacookie"   # or server's private key
    nonce = str(now)
    hashable = idToken + backendSecret + nonce
    fishbowlID = hashlib.sha256(hashable.strip().encode('utf-8')).hexdigest()
    fishbowlID = fishbowlID[:10]

    # Lifetime of fishbowlID is min of time to idToken expiration
    # (int()+1 is just ceil()) and target lifetime, which should
    # be less than idToken lifetime (~1 hour).
    lifetime = min(int(idinfo['exp']-now)+1, 60 * 60) # secs, up to idToken's lifetime

    cursor = connection.cursor()
    # clean up db table of expired chatterIDs
    cursor.execute('DELETE FROM fishes WHERE %s > expiration;', (now, ))

    # insert new fishbowlID
    # Ok for chatterID to expire about 1 sec beyond idToken expiration
    cursor.execute('INSERT INTO fishes (fishbowlID, username, expiration, email) VALUES '
                   '(%s, %s, %s, %s);', (fishbowlID, username, now+lifetime, email))

    # Return chatterID and its lifetime
    cursor.execute("SELECT * FROM users WHERE email = '{}';".format(email))
    rows = cursor.fetchall()
    user_info = {}
    profile_exists = False
    if len(rows) > 0:
        user_info = {cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))}
        profile_exists = True
            
    return JsonResponse({'fishbowlID': fishbowlID,  'lifetime': lifetime, "idinfo": idinfo, "user_info": user_info, "profile_existed": profile_exists})


# NOT BEING USED?
@csrf_exempt
def postauth(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)

    fishbowlID = json_data['fishbowlID']
  #  message = json_data['message']

    cursor = connection.cursor()
    cursor.execute('SELECT username, expiration FROM fishes WHERE fishbowlID = %s;', (fishbowlID,))

    row = cursor.fetchone()
    now = time.time()
    if row is None or now > row[1]:
        # return an error if there is no chatter with that ID
        return HttpResponse(status=401) # 401 Unauthorized

    # Else, insert into the chatts table
    # cursor.execute('INSERT INTO chatts (username, message) VALUES (%s, %s);', (row[0], message))
    return JsonResponse({})

@csrf_exempt
def postblock(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    sender = json_data['sender']
    receiver = json_data['receiver']

    cursor = connection.cursor()
    cursor.execute("INSERT INTO blocks (sender, receiver) VALUES ('{}', '{}');".format(sender, receiver))
    cursor.execute("SELECT * FROM blocks WHERE sender = '{}';".format(sender))
    rows = cursor.fetchall()
    response = {
        "blocks" : rows
    }

    return JsonResponse(response)


@csrf_exempt
def getblocks(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    sender = request.GET.get('sender')

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM blocks WHERE sender = '{}';".format(sender))
    rows = cursor.fetchall()
    blocks = []
    for row in rows:
        # get the receiver information
        cursor.execute("SELECT * FROM users WHERE email = '{}';".format(row[1]))
        receiver = cursor.fetchone()
        blocks.append({cursor.description[i][0]: receiver[i] for i in range(len(cursor.description))}) 

    response = {
        "blocks" : blocks
    }

    return JsonResponse(response)

@csrf_exempt
def updatebio(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    email = json_data['email']
    bio = json_data['bio']

    cursor = connection.cursor()
    cursor.execute("UPDATE users SET bio = '{}' WHERE email = '{}';".format(bio, email))
    return JsonResponse()
