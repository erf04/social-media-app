from django.shortcuts import render
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .serializers import TaskSerializer
from .models import Task
from django.shortcuts import get_object_or_404
# Create your views here.


@api_view(['GET'])
def hello(request:Request):
    return Response(
        {"message":"hello world"},status=status.HTTP_200_OK)


@api_view(['GET'])
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

