from django.urls import re_path,path

from . import consumers

websocket_urlpatterns = [
    path("ws/group/<str:room_name>/", consumers.GroupConsumer.as_asgi()),
    path("ws/pv/<int:chat_id>/", consumers.PrivateChatConsumer.as_asgi()),
]