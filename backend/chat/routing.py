from django.urls import re_path,path

from . import consumers

websocket_urlpatterns = [
    path("ws/group/<str:roomname>/", consumers.ChatConsumer.as_asgi()),
    path("ws/chat/", consumers.GroupConsumer.as_asgi()),
]