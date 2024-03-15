from django.shortcuts import render
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view,permission_classes,parser_classes
from .serializers import TaskSerializer,UserSerializer,PostSerializer,FollowerSerializer
from .models import *
from django.shortcuts import get_object_or_404
from .permissions import IsOwnerOrReadOnly
from rest_framework import permissions,generics
from rest_framework.parsers import MultiPartParser, FormParser
from chat.serializers import CompleteUserSerializer
from rest_framework import generics
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

@api_view(['POST','PUT'])
@permission_classes([permissions.IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def create_post(request:Request):

    print(request.data)
    post=PostSerializer(data=request.data,many=False)
   
    if post.is_valid():
        post.save(author=request.user)
        
        return Response({
        "ok":True,
        },status=status.HTTP_200_OK)
    else:
        print(post.errors)
        return  Response("Error", status=status.HTTP_503_SERVICE_UNAVAILABLE)
    


@api_view(['POST'])
def getUserByUsername(request:Request):
    username = request.data['username']
    user= User.objects.get(username=username)
    serializer = UserSerializer(user)
    return Response(serializer.data)


class getAllCompletedUsers(generics.ListAPIView):
    serializer_class=CompleteUserSerializer
    permission_classes=[permissions.IsAuthenticated]

    def get_queryset(self):
        return User.objects.all()
    
    def get_serializer_context(self):
        context= super().get_serializer_context()
        context['request']=self.request
        return context



@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def filter_users(request:Request):
    key=request.data["key"]
    users=User.objects.filter(username__contains=key)
    serialized=UserSerializer(users,many=True)
    return Response(serialized.data,status=status.HTTP_200_OK)
    

class filterCompletedUsers(generics.ListAPIView):
    serializer_class=CompleteUserSerializer
    permission_classes=[permissions.IsAuthenticated]

    # def get_queryset(self):
    #     key=self.request.query_params.get("key")
    #     return User.objects.filter(username__contains=key)
    
    def post(self,request,*args,**kwargs):
        key = request.data.get("key")
        queryset = User.objects.filter(username__contains=key)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data,status=status.HTTP_200_OK)
    

    def get_serializer_context(self):
        context= super().get_serializer_context()
        context['request']=self.request
        return context



@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def add_following(request:Request):
    followed_id=request.data["following_id"]
    follower=request.user
    followed=User.objects.get(pk=followed_id)
    followerObj=Follower.objects.create(follower=follower,followed=followed)
    serialized=FollowerSerializer(followerObj,many=False)
    return Response(serialized.data,status=status.HTTP_201_CREATED)

@api_view(['GET'])
def get_followers(request:Request):
    pass

@api_view(['GET'])
def get_followings(request:Request):
    pass



    





