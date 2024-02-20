from . import views
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainSlidingView,
    TokenRefreshSlidingView,
    TokenObtainPairView,
    TokenRefreshView
)
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path("hello/",views.hello,name="hello"),
    path("tasks/",views.getTasks,name="getTasks"),
    path("tasks/<int:id>/",views.getTask,name="getTask"),
    path("tasks/create/",views.createTask,name="createTask"),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)