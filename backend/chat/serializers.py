from rest_framework import serializers
from api.models import Group,User,Message,CommentContainer
from api.serializers import UserSerializer,PostSerializer


class GroupSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False,required=False)
    creation_date = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    participants=UserSerializer(many=False,required=False)
    
    class Meta:
        model=Group
        fields=('id','name','creator','creation_date','paticipants')


class CommentContainerSerializer(serializers.ModelSerializer):
    # messages=MessageSerializer(many=True,required=False)
    class Meta:
        model=CommentContainer
        fields=('id','messages')



class MessageChatField(serializers.RelatedField):
    
    def to_representation(self, value):
        if isinstance(value, Group):
            serializer=GroupSerializer(value)

        return serializer
    

# class MessageSerializer()