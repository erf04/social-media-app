import json

from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from api.models import  User,PrivateChat

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
        print(f"disconnect with {self.channel_name}")
        pass

    async def receive(self, text_data):
        print(text_data)
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        await self.send(text_data=json.dumps({"message": message}))





class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        # Assume you have the user object available
        user:User = self.scope['user']

        # Store the channel_name in the database
        
        await self.set_channel_name(user)

        print(user.channel_name)
        await self.accept()

    @database_sync_to_async
    def set_channel_name(self,user:User):
        # This is a synchronous function that returns a result
        user.channel_name=self.channel_name
        user.save()

    @database_sync_to_async
    def get_private_chat(creator,the_other):
        # Create or retrieve a PrivateChat instance
        private_chat, created = PrivateChat.objects.get_or_create(creator=creator,the_other=the_other)
        private_chat.save()
