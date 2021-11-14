from django.shortcuts import render

# Create your views here.
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import JsonResponse, HttpResponse
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from google.oauth2 import id_token
from google.auth.transport import requests

import hashlib
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

    if users_id is None:
        return JsonResponse(response)
    
    for user_id in users_id:
        cursor.execute("SELECT * FROM users WHERE email = '{}';".format(user_id))
        rows = cursor.fetchall()
        response['users'][user_id] = {
            cursor.description[i][0]: rows[0][i] for i in range(len(cursor.description))
        }
    return JsonResponse(response)

@csrf_exempt
def postlikes(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    sender = json_data['sender']
    receiver = json_data['receiver']
    sender_receiver = str(sender) + "_" + str(receiver)
    receiver_sender = str(receiver) + "_" + str(sender)
    cursor = connection.cursor()
    cursor.execute('INSERT INTO likes (sender_receiver) VALUES '
                '(%s) ON CONFLICT (sender_receiver) DO NOTHING;', (sender_receiver,))

    cursor.execute('SELECT * FROM likes WHERE sender_receiver = %s;', (receiver_sender,))
    rows = cursor.fetchall()
    response = {}
    
    if rows:
        response['status'] = 'matched'
    cursor.execute('INSERT INTO matches (sender, receiver) VALUES (%s,%s);',(str(sender), str(receiver)))

    return JsonResponse(response)

@csrf_exempt
def createusers(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    username = request.POST.get("username")
    fullname = request.POST.get("fullname")
    display_name = request.POST.get("display_name")
    email = request.POST.get("email")
    bio = request.POST.get("bio")

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = display_name+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        imageurl = None
    
    cursor = connection.cursor()
    cursor.execute('INSERT INTO users (fullname, display_name, email, bio, imageurl, username) VALUES '
                '(%s,%s,%s,%s,%s,%s) ON CONFLICT (email) DO NOTHING;', (fullname,display_name,email,bio,imageurl,username))
    
    cursor.execute('SELECT id FROM users WHERE email = %s;', (email,))
    rows = cursor.fetchall()
    
    response = {}
    response['user_id'] = rows  
    
    return JsonResponse(response)

def getmatches(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    sender = request.GET.get('sender')
    response = {}
    cursor = connection.cursor()
    if sender is None:
        return JsonResponse(response)
    cursor.execute('SELECT * FROM matches WHERE sender = %s;', (sender))
    rows = cursor.fetchall()
    response['matches'] = rows

    return JsonResponse(response)

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

    # Lifetime of chatterID is min of time to idToken expiration
    # (int()+1 is just ceil()) and target lifetime, which should
    # be less than idToken lifetime (~1 hour).
    lifetime = min(int(idinfo['exp']-now)+1, 60) # secs, up to idToken's lifetime

    cursor = connection.cursor()
    # clean up db table of expired chatterIDs
    cursor.execute('DELETE FROM fishes WHERE %s > expiration;', (now, ))

    # insert new chatterID
    # Ok for chatterID to expire about 1 sec beyond idToken expiration
    cursor.execute('INSERT INTO fishes (fishbowlID, username, expiration) VALUES '
                   '(%s, %s, %s);', (fishbowlID, username, now+lifetime))

    # Return chatterID and its lifetime
    return JsonResponse({'fishbowlID': fishbowlID, 'lifetime': lifetime})

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
