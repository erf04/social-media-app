import json

from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from api.models import  User,PrivateChat,Message

class GroupConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"chat_{self.room_name}"

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name, self.channel_name
        )

        self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name, self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name, {
                "type": "chat.message",
                "message": message
            }
        )

    # Receive message from room group
    def chat_message(self, event):
        message = event["message"]

        # Send message to WebSocket
        self.send(text_data=json.dumps({
            "message": message,

        }))


    @database_sync_to_async
    def create_new_message(self,text_data):
        #reply_to,chat,body
        user=self.scope['user']
        if not user.is_authenticated:
            return {'error':'Must be logged in'}
            
        reply_to=text_data["reply_to"]
        body=text_data["body"]
        chat=self.room_name
        message=Message.objects.create(chat=chat,body=body,reply_to=reply_to)





class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        # await self.accept()
        print(self.scope)
        # Assume you have the user object available
        user:User = self.scope['user']

        # Store the channel_name in the database
        
        await self.set_channel_name(user)

        
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


    async def disconnect(self, code):
        return await super().disconnect(code)
    

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        await self.send(text_data=json.dumps({"message": message}))
