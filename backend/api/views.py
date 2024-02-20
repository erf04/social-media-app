from django.shortcuts import render
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view,permission_classes
from .serializers import TaskSerializer,UserSerializer,FollowerSerializer,PostSerializer
from .models import *
from django.shortcuts import get_object_or_404
from .permissions import IsOwnerOrReadOnly
from rest_framework import permissions
# Create your views here.


@api_view(['GET'])
def hello(request:Request):
    return Response(
        {"message":"hello world"},status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def getTasks(request:Request):
    tasks = Task.objects.all()
    serializer = TaskSerializer(tasks, many=True)
    if tasks.exists():
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response({"message": "No tasks found"}, status=status.HTTP_204_NO_CONTENT)

# @api_view(['GET'])
# def getTask(request:Request,id):
#     try:
#         task=Task.objects.get(pk=id)
#         serialized=TaskSerializer(task,many=False)
#         return Response(data=serialized.data,status=status.HTTP_302_FOUND)
#     except:
#         return Response({"error":"task not found"},status=status.HTTP_404_NOT_FOUND)
    

@api_view(['GET'])

def getTask(request, id):
    task = get_object_or_404(Task, pk=id)
    serializer = TaskSerializer(task)
    print(serializer)
    return Response(data=serializer.data, status=status.HTTP_200_OK)


@api_view(['POST'])
def createTask(request:Request):
    serialized=TaskSerializer(data=request.data)
    if serialized.is_valid():
        serialized.save()
        return  Response(serialized.data,status=status.HTTP_201_CREATED)
    return Response(serialized.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def show_allposts(request:Request):
    serialized=PostSerializer(Post.objects.all(),many=True)
    return Response(serialized.data,status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsOwnerOrReadOnly])
def showUserPosts(request:Request):
    print(request.user)
    posts= Post.objects.filter(author=request.user)
    serialized=PostSerializer(posts, many=True)
    return Response(serialized.data,status=status.HTTP_200_OK)





