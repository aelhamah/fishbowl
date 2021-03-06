"""routing URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('getusers/', views.getusers, name='getusers'),
    path('postlikes/', views.postlikes, name='postlikes'),
    path('createusers/', views.createusers, name='createusers'),
    path('getmatches/', views.getmatches, name='getmatches'),
    path('postauth/', views.postauth, name='postauth'),
    path('adduser/', views.adduser, name='adduser'),
    path('postblock/', views.postblock, name='postblock'),
    path('getblocks/', views.getblocks, name='getblocks'),
    path('updatebio/', views.updatebio, name='updatebio'),
]
