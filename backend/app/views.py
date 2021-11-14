from django.shortcuts import render

# Create your views here.
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import JsonResponse, HttpResponse


def getusers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    user_ids = json_data['user_id']
   

    response = {}
    response['users'] = []
    cursor = connection.cursor()

    for user_id in user_ids:
        cursor.execute("""
                        SELECT * FROM users WHERE id = %s;""", (user_id,))
        rows = cursor.fetchall()
        response['users'].append(rows)
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



