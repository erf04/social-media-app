import json

from channels.generic.websocket import AsyncWebsocketConsumer
from .serializers import MessageSerializer,GroupSerializer,GroupAdminSerializer

from channels.db import database_sync_to_async
from channels.layers import get_channel_layer
from channels.db import database_sync_to_async
from api.models import  User,PrivateChat,Message,Group,GroupAdmin
from .serializers import MessageSerializer,GroupSerializer,PrivateChatSerializer
from api.serializers import UserSerializer
import datetime
import copy

class GroupConsumer(AsyncWebsocketConsumer):

        
    async def connect(self):
        room_id = self.scope["url_route"]["kwargs"]["room_id"]
        print(room_id)
        self.room:Group=await self.get_room(room_id)
        self.room_type=self.room.__class__.__name__.lower()
        self.room_name=self.room.id
        # group_name=self.room_name.replace(" ","_")
        self.room_group_name = f"chat_{self.room_name}"
        print(f"user: {self.scope['user']}")
        print(f"group {self.room_group_name}")
    
        self.user=copy.deepcopy(self.scope['user'])
        print(f"user: {self.user}")

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name, self.channel_name
        )

        
        await self.accept()
        # await self.send(text_data=json.dumps({"message":"connected successfully"}))

#      @database_sync_to_async
#      def add_to_group(self):
#         self.scope['user']
        

    @database_sync_to_async
    def get_room(self,id):
        return Group.objects.get(pk=id)


    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name, self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)

        # print(text_data_json)

        
        command = text_data_json["command"]
        # self.send_to_chat_message(text_data)
        if command=="new_message":
            result=await self.create_new_message(text_data_json)
            await self.send_to_chat_message(result,command="new_message")

        elif command=="fetch_messages":

            result=await self.fetch_messages() 
       
            await self.chat_message(result)

        elif command=="set_admin":
            result=await self.set_admin(text_data_json)
            await self.send_to_chat_message(result,command="set_admin")


        elif command=="is_typing":
            result=await self.is_typing()
            await self.send_to_chat_message(result,command="is_typing")

        elif command=="stop_typing":
            result=""
            await self.send_to_chat_message(result,command="stop_typing")

        elif command=="add_viewer":
            result=await self.add_viewer(text_data_json)
            if (result!=None):
                await self.send_to_chat_message(result,command="add_viewer")
            else:
                self.send(json.dumps({
                    "message":"unexpected error" 
                }))

    


    async def send_to_chat_message(self,text_data,command):
        
     
        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name, {
                "type": "chat.message",
                "data":text_data,
                "command":command

            }
        )

    # Receive message from room group
    async def chat_message(self, event):
        # message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps(event))



    
    @database_sync_to_async
    def create_new_message(self,text_data):
        #reply_to,chat,body
    #         user:User=self.scope['user']
        
        user=self.user
        print(self.room_name,user)
        if not user.is_authenticated:
            return {'error':'Must be logged in'}
            
        reply_to_id=text_data["message"]["reply_to_id"]
        body=text_data["message"]["body"]
        base64_image=text_data["message"].get("image",None)

        try:
            replied_message=Message.objects.get(pk=reply_to_id) if reply_to_id!=None else None
        except:
            return {"error":f"there is no message with id:{reply_to_id} to be a replied message"}
        print(user)
        group:Group=self.room
        print(group)
        # message:Message=Message.objects.create(sender=user,chat=group,body=body,reply_to=replied_message,timestamp=datetime.datetime.now())
        message=Message.create_from_base64(base64_string=base64_image) if  base64_image else Message()
        message.sender=user
        message.chat=group
        message.body=body
        message.reply_to=replied_message
        message.timestamp=datetime.datetime.now()
        message.save()
        
        serialized=MessageSerializer(message,many=False)
        print(serialized.data)
        # self.send_to_chat_message(serialized.data)
        return serialized.data


    @database_sync_to_async
    def fetch_messages(self):
        
        user=self.user
        print(self.room_name,user)
        # user=User.objects.get(pk=user.id)

        messages=Message.message_order(self,self.room,self.room_type)

        dict_messages=MessageSerializer(messages,many=True).data
        group_serialized=GroupSerializer(self.room,many=False).data
        return {
            "command":"fetch_messages",
            "messages":dict_messages,
            "chat_info":group_serialized
        }
    
    @database_sync_to_async
    def set_admin(self,text_data:dict):
        is_staff=text_data['is_staff']
        user_id=text_data['user']
        admins=self.room.admins.all()
        try:
            admin=GroupAdmin.objects.get(user=self.user,group=self.room)
        except:
            admin=None
            
        if (admin in admins and admin.is_staff) or (self.user == self.room.creator):
            new_admin=User.objects.get(pk=user_id)
            
            group_admin=GroupAdmin.objects.create(group=self.room,supervisor=self.user,is_staff=is_staff,user=new_admin,creation_time=datetime.datetime.now())
            serialized=GroupAdminSerializer(group_admin,many=False)
            return serialized.data
        else:
            self.send(json.dumps({
                "error":"you don't have permission"
            }))


    async def is_typing(self):
        user= self.user
        return UserSerializer(user,many=False).data
    
    @database_sync_to_async
    def add_viewer(self,text_data:dict):
        message_id=text_data["message_id"]
        user=self.user
        try:
            message=Message.objects.get(pk=message_id)
            message.seen_by.add(user)
        except:
            self.send(json.dumps({
                "error":f"message with id: {message_id} dosn't exist"
            }))

        return MessageSerializer(message,many=False).data

    




        
        





class PrivateChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        chat_id=self.scope["url_route"]["kwargs"]["chat_id"]
        self.user=self.scope["user"]
        self.room_group_name=""
        # get chat object from id
        try:
            chat:PrivateChat=await self.get_private_chat(chat_id)
            self.chat=chat
            self.chat_type=self.chat.__class__.__name__.lower()
            # check if the user is creator or the_other user
            current_user=self.scope['user']
            print(current_user)
            if not await self.check_permission(current_user):
                print("in if")
                # await self.send(json.dumps({
                #     "error":f"user {current_user} dont have access to this room"
                # }))
                await self.close()


            else:
                print("in else")
                # self.room_group_name=f"user_{chat.creator}_{chat.the_other}" 
                await self.set_group_name()
                await self.channel_layer.group_add(
                    self.room_group_name, self.channel_name
                )
                await self.accept()




        except Exception as e:
        # print(e)
            await self.send(json.dumps({
                "error":f"no such private chat with id : {chat_id}"
            }))
            await self.close()

    
    @database_sync_to_async
    def get_private_chat(self,id):
        return PrivateChat.objects.get(pk=id)
    
    @database_sync_to_async
    def check_permission(self,user):
        if (self.chat.creator==user or self.chat.the_other==user):
            return True
        return False
    
    @database_sync_to_async
    def set_group_name(self):
        self.room_group_name=f"pv_{self.chat.creator.username}_{self.chat.the_other.username}" 
        
        

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
            result=await self.create_new_message(text_data_json)
            await self.send_to_chat_message(result,command="new_message")

        elif command=="fetch_messages":
            result=await self.fetch_messages() 
       
            await self.chat_message(result)

        elif command=="is_typing":
            result=await self.is_typing()
            await self.send_to_chat_message(result,command="is_typing")

        elif command=="stop_typing":
            result=""
            await self.send_to_chat_message(result,command="stop_typing")



     # Receive message from room group
    

    async def send_to_chat_message(self,text_data,command):
        
     
        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name, {
                "type": "chat.message",
                "data":text_data,
                "command":command

            }
        )


    # Receive message from room group
    async def chat_message(self, event):
        # message = event["message"]

        # Send message to WebSocket
        await self.send(text_data=json.dumps(event))


    @database_sync_to_async
    def create_new_message(self,text_data):
        #reply_to,chat,body
    #         user:User=self.scope['user']
        
        user:User=self.user
        # print(self.room_name,user)
        if not user.is_authenticated:
            return {'error':'Must be logged in'}
            
        reply_to_id=text_data["message"]["reply_to_id"]
        body=text_data["message"]["body"]
        base64_image=text_data["message"].get("image",None)

        try:
            replied_message=Message.objects.get(pk=reply_to_id) if reply_to_id!=None else None
        except:
            return {"error":f"there is no message with id:{reply_to_id} to be a replied message"}
        print(user)
        

        pv:PrivateChat=self.chat
        print(pv)
        # message:Message=Message.objects.create(sender=user,chat=group,body=body,reply_to=replied_message,timestamp=datetime.datetime.now())
        message=Message.create_from_base64(base64_string=base64_image) if  base64_image else Message()
        message.sender=user
        message.chat=pv
        message.body=body
        message.reply_to=replied_message
        message.timestamp=datetime.datetime.now()
        message.save()
        
        serialized=MessageSerializer(message,many=False)
        print(serialized.data)
        # self.send_to_chat_message(serialized.data)
        return serialized.data



    @database_sync_to_async
    def fetch_messages(self):
        
        print(self.room_group_name,self.user)
        # user=User.objects.get(pk=user.id)
        
        messages=Message.message_order(self,self.chat,self.chat_type)
        
        dict_messages=MessageSerializer(messages,many=True).data
        # print(messages)
        group_serialized=PrivateChatSerializer(self.chat,many=False).data
        return {
            "command":"fetch_messages",
            "messages":dict_messages,
            "chat_info":group_serialized
        }
    
    async def is_typing(self):
        user= self.user
        return UserSerializer(user,many=False).data
        

    
