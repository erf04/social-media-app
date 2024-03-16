from rest_framework.request import Request
from rest_framework.response import Response 
from .serializers import GameSerializer
from rest_framework.decorators import api_view,permission_classes
from rest_framework import permissions
from api.models import Game,GameLog
from rest_framework import status


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def games_list(request:Request):
    games=Game.objects.all()
    serialized=GameSerializer(games,many=True)
    return Response(serialized.data,status=status.HTTP_200_OK)
    

