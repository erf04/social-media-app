from django.shortcuts import render
from rest_framework.request import Request
from rest_framework.response import Response
from api.models import Group
from rest_framework import status
from rest_framework.decorators import api_view,permission_classes,parser_classes
from .serializers import GroupSerializer
from .models import *
from django.shortcuts import get_object_or_404
from api.permissions import IsOwnerOrReadOnly
from rest_framework import permissions,generics
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.views import APIView


class GroupApiView(APIView):
    def get(self,request:Request):
        groups=Group.objects.filter(participants=request.user)
        serialized=GroupSerializer(groups,many=True)
        return Response(serialized.data,status=status.HTTP_200_OK)

    def post(self,request:Request): 
        group_name=request.data['group_name']
        group=Group.objects.create(name=group_name,creator=request.user)
        group.participants.add(request.user)
        group.save()
        serialized=GroupSerializer(group, many=False)
        return Response(serialized.data,status=status.HTTP_201_CREATED)

