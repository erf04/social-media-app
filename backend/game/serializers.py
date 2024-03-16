from api.models import Game,GameLog
from rest_framework import serializers

class GameSerializer(serializers.ModelSerializer):
    class Meta:
        model= Game
        fields=('id','name','description','image')

