from django.urls import re_path,path

from . import consumers

websocket_urlpatterns = [
    path("ws/group/<int:room_id>/", consumers.GroupConsumer.as_asgi()),
    path("ws/pv/<int:chat_id>/", consumers.PrivateChatConsumer.as_asgi()),
]