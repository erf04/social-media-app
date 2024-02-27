
import json

from channels.generic.websocket import AsyncWebsocketConsumer


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        print(f'self.channel_name {self.channel_name} , self.channel_receive {self.channel_receive.__str__}')
        await self.accept()

    async def disconnect(self, close_code):
        print("disconnect")
        pass

    async def receive(self, text_data):
        print(text_data)
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        await self.send(text_data=json.dumps({"message": message}))