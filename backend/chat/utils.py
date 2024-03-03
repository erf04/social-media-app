from channels.layers import get_channel_layer
from channels.db import database_sync_to_async
from api.models import  User,PrivateChat,Message,Group
from .serializers import MessageSerializer,GroupSerializer
import datetime



@database_sync_to_async
def create_new_message(self,text_data):
    #reply_to,chat,body
#         user:User=self.scope['user']
    sender_id=text_data["message"]["sender_id"]
    user=User.objects.get(pk=sender_id)
    print(sender_id)
    if not user.is_authenticated:
        return {'error':'Must be logged in'}
        
    reply_to_id=text_data["message"]["reply_to_id"]
    body=text_data["message"]["body"]
    chat_name=self.room_name
    try:
        replied_message=Message.objects.get(pk=reply_to_id) if reply_to_id!=None else None
    except:
        return {"error":f"there is no message with id:{reply_to_id} to be a replied message"}
    print(user)
    group:Group=Group.objects.filter(participants=user,name=chat_name).first()
    print(group)

    message:Message=Message.objects.create(sender=user,chat=group,body=body,reply_to=replied_message,timestamp=datetime.datetime.now())

    
    serialized=MessageSerializer(message,many=False)
    print(serialized.data)
    # self.send_to_chat_message(serialized.data)
    return serialized.data


@database_sync_to_async
def fetch_messages(self,text_data):
    user:User=User.objects.get(pk=text_data['sender_id'])
    self.room_object=Group.objects.get(name=self.room_name,participants=user)
    messages=Message.message_order(self,user,self.room_name)
    dict_messages=MessageSerializer(messages,many=True).data
    group_serialized=GroupSerializer(self.room_object,many=False).data
    return {
        "command":"fetch_messages",
        "messages":dict_messages,
        "chat_info":group_serialized
    }
    

