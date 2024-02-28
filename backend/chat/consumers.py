import json

from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from api.models import  User

class GroupConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        user:User=self.scope["user"]
        await self.set_channel_name(user)
        print(user.channel_name)
        await self.accept()

    @database_sync_to_async
    def set_channel_name(self,user:User):
        # This is a synchronous function that returns a result
        user.channel_name=self.channel_name
        user.save()

    async def disconnect(self, close_code):
        print("disconnect")
        pass

    async def receive(self, text_data):
        print(text_data)
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        await self.send(text_data=json.dumps({"message": message}))





class ChatConsumer(AsyncWebsocketConsumer):
    pass