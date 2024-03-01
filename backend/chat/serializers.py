from rest_framework import serializers
from api.models import Group,User,Message
from api.serializers import UserSerializer


class GroupSerializer(serializers.ModelSerializer):
    creator=UserSerializer(many=False,required=False)
    creation_date = serializers.DateTimeField(format="%Y-%m-%d %H:%M:%S")
    participants=UserSerializer(many=False,required=False)
    
    class Meta:
        model=Group
        fields=('id','name','creator','creation_date','paticipants')