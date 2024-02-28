from django.contrib import admin
from .models import *

# Register your models here.

admin.site.register(Task)
admin.site.register(User)
admin.site.register(Follower)
admin.site.register(Chat)
admin.site.register(Message)
admin.site.register(Forward)
admin.site.register(CommentContainer)
admin.site.register(Group)
admin.site.register(PrivateChat)


