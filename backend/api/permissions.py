from rest_framework import permissions
from .models import Post
from rest_framework.request import Request


class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request:Request, view, obj:Post):
       
        if request.method in permissions.SAFE_METHODS:
            return True

        # Instance must have an attribute named `owner`.
        return obj.author == request.user
