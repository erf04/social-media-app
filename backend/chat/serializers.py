from rest_framework import serializers
from api.models import Group,User,Message,CommentContainer,PrivateChat
from api.serializers import UserSerializer,PostSerializer


class GroupSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False,required=False)
    creation_date = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    participants=UserSerializer(many=True,required=False)
    
    class Meta:
        model=Group
        fields=('id','name','creator','creation_date','participants','image')


class CommentContainerSerializer(serializers.ModelSerializer):
    # messages=MessageSerializer(many=True,required=False)
    class Meta:
        model=CommentContainer
        fields=('id','messages')



# class MessageChatField(serializers.RelatedField):
    
#     def to_representation(self, value):
#         if isinstance(value, Group):
#             serializer=GroupSerializer(value)
#         elif isinstance(value,CommentContainer):
#             serializer="CommentContainerSerializer"()
#         return serializer
    

class MessageSerializer(serializers.ModelSerializer):
    sender=UserSerializer(many=False,required=False)
    timestamp=serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S",read_only=True)
    liked_by=UserSerializer(many=True, required=False)
    saved_by=UserSerializer(many=True,required=False)
    class Meta:
        model=Message
        fields=('id','sender','reply_to','liked_by','saved_by','body','timestamp')


class PrivateChatSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False)
    the_other=UserSerializer(many=False)
    class Meta:
        model=PrivateChat
        fields=('id','creator','the_other')