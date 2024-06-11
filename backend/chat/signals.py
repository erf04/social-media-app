from django.db.models.signals import post_save
from django.dispatch import receiver
from api.models import Message
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from api.models import Group
from .serializers import MessageSerializer
import json


def notify_clients(instance:Message):
    print("in notif1")
    channel_layer = get_channel_layer()
    group_name = f"chat_{instance.chat.id}"
    serializer=MessageSerializer(instance,many=False)
    print("in notify2")
    async_to_sync(channel_layer.group_send)(
        group_name,
        {
            'type': 'chat_message',
            'message': serializer.data,
            'command':"notif"
        }
    )


@receiver(post_save, sender=Message)
def notify_new_message(sender, instance, created, **kwargs):
    print(f"signal {instance},{created}")
    if created:
        # Call a function to send the notification
        notify_clients(instance)
