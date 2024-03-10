from django.shortcuts import render
from rest_framework.request import Request
from rest_framework.response import Response
from api.models import Group,PrivateChat,User,Follower
from rest_framework import status
from rest_framework.decorators import api_view,permission_classes,parser_classes
from .serializers import GroupSerializer,PrivateChatSerializer
from .models import *
from django.shortcuts import get_object_or_404
from api.permissions import IsOwnerOrReadOnly
from rest_framework import permissions,generics
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.views import APIView
from django.db.models import Q
from datetime import datetime
from .serializers import CompleteUserSerializer
from itertools import chain

class GroupApiView(APIView):
    permission_classes=[permissions.IsAuthenticated]
    def get(self,request:Request):
        groups=Group.objects.filter(participants=request.user)
        serialized=GroupSerializer(groups,many=True)
        return Response(serialized.data,status=status.HTTP_200_OK)

    def post(self,request:Request): 
        group_name=request.data['group_name']
        image=request.data['image']
        group=Group.objects.create(name=group_name,creator=request.user,image=image,creation_date=datetime.now())
        group.participants.add(request.user)
        group.save()
        serialized=GroupSerializer(group, many=False)
        return Response(serialized.data,status=status.HTTP_201_CREATED)
    


class PrivateRoomView(APIView):
    permission_classes=[permissions.IsAuthenticated]
    def get(self,request:Request):
        private_chats=PrivateChat.objects.filter(Q(creator=request.user) | Q(the_other=request.user))
        serialized=PrivateChatSerializer(private_chats,many=True)
        return Response(serialized.data,status=status.HTTP_200_OK)

    def post(self,request:Request):
        other_id=request.data["other_id"]
        the_other=User.objects.get(pk=other_id)
        private_chat,created=PrivateChat.objects.get_or_create(creator=request.user,the_other=the_other)
        serialized=PrivateChatSerializer(private_chat,many=False)
        if created:
            return Response(serialized.data,status=status.HTTP_201_CREATED)
        return Response(serialized.data,status=status.HTTP_200_OK)
    

@api_view(["POST"])
@permission_classes([permissions.IsAuthenticated])
def add_participants_to_last_group(request:Request):
    participants_id_list=request.data["participants"]
    print(f"ids:{participants_id_list}")
    myuser=request.user
    last_group=Group.objects.filter(creator=myuser).last()
    for id in  participants_id_list:
        user=User.objects.get(pk=id)
        last_group.participants.add(user)

    serialized=GroupSerializer(last_group,many=False)
    return Response(serialized.data,status=status.HTTP_200_OK)


@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def get_followers_and_followings(request:Request):
    user:User=request.user

    followers=User.objects.filter(followings__followed=user)
    followings=User.objects.filter(followers__follower=user)
    users=followers | followings
    serializer=CompleteUserSerializer(users,many=True)
    return Response(serializer.data,status=status.HTTP_200_OK)



