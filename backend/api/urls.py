from . import views
from django.urls import path

urlpatterns = [
    path("hello/",views.hello,name="hello"),
    path("fetchall/",views.getTasks,name="getTasks"),
    path("fetch/<int:id>/",views.getTask,name="getTask"),
]
