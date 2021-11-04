from django.shortcuts import render

# Create your views here.
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import JsonResponse, HttpResponse
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage

def getusers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
#probably best bet is to create a string separated by commas
    users_id_raw = request.GET.getlist('user_ids')
    users_id = []
    #user_ids = request.query_params.get('user_ids', None)
#    user_ids = request.resolver_match.kwargs.get('user_ids')
   # user_list = []
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
        cursor.execute("""
                        SELECT * FROM users WHERE id = %s;""", (int(user_id),))
        rows = cursor.fetchall()
        response['users'][user_id] = {
            # cursor.description[i][0]: rows[i] for i in range(len(cursor.description))
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
    return JsonResponse(response)

@csrf_exempt
def createusers(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    fullname = json_data['fullname']
    display_name = json_data['display_name']
    email = json_data['email']
    
    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = username+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        imageurl = None
    
    cursor = connection.cursor()
    cursor.execute('INSERT INTO users (fullname, display_name, email, imageurl) VALUES '
                '(%s,%s,%s,%s) ON CONFLICT (email) DO NOTHING;', (fullname,display_name,email,imageurl))
    
    
    cursor.execute('SELECT id FROM users WHERE email = %s;', (email,))
    rows = cursor.fetchall()
    
    response = {}
    response['user_id'] = rows  
    
    return JsonResponse({response})

