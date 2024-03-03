import json

from channels.generic.websocket import AsyncWebsocketConsumer
from .serializers import MessageSerializer,GroupSerializer
from .utils import create_new_message,fetch_messages
class GroupConsumer(AsyncWebsocketConsumer):

    
    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"chat_{self.room_name}"
        print(self.groups)
        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name, self.channel_name
        )

        print('to accept')
        await self.accept()

#      @database_sync_to_async
#      def add_to_group(self):
#         self.scope['user']


    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name, self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        print(text_data_json)
        
        
        command = text_data_json["command"]
        # self.send_to_chat_message(text_data)
        if command=="new_message":
            result=await create_new_message(text_data_json)
            await self.send_to_chat_message(result)

        elif command=="fetch_messages":
            result=await fetch_messages(text_data_json) 
       
            await self.chat_message(result)

        # elif command=="change_permission":
        #     type=text_data_json["command_type"]
        #     selected_user_id=text_data_json["selected_user_id"]
        #     command_caller_id=text_data_json["command_caller_id"]
        #     if type=="to_admin":





    async def send_to_chat_message(self,text_data):
        
     
        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name, {
                "type": "chat.message",
                "data":text_data,
                "command":"new_message"

            }
        )

    # Receive message from room group
    async def chat_message(self, event):
        # message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps(event))



class PrivateChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        chat_id=self.scope["url_route"]["kwargs"]["chat_id"]
        # get chat object from id
        # check if the user is creator or the_other user
        await self.accept()

    # @database_sync_to_async
    # def set_channel_name(self,user:User):
    #     # This is a synchronous function that returns a result
    #     user.channel_name=self.channel_name
    #     user.save()

    # @database_sync_to_async
    # def get_private_chat(creator,the_other):
    #     # Create or retrieve a PrivateChat instance
    #     private_chat, created = PrivateChat.objects.get_or_create(creator=creator,the_other=the_other)
    #     private_chat.save()


    async def disconnect(self, code):
        return await super().disconnect(code)
    

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        # await self.send(text_data=json.dumps({"message": message}))
        await self.chat_message(text_data_json)

    # async def send_message(self,channel_name, message):
    #     # channel_layer = get_channel_layer()
    #     await channel_layer.send(channel_name, {
    #         'type': 'chat.message',
    #         'message': message
    #     })

    # async def send_message_to_user(self,user_id, message):
    #     # Assuming you have a unique channel name for each user, for example, "user_{user_id}"
    #     channel_name = f"user_{user_id}"
    #     self.send_messasge(channel_name, message)

     # Receive message from room group
    async def chat_message(self, event):
        message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps({"message": message}))

    




class testConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"chat_{self.room_name}"

        # Join room group
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)

        await self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name, {"type": "chat.message", "message": message}
        )

    # Receive message from room group
    async def chat_message(self, event):
        message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps({"message": message}))
