from django.urls import path,include
from . import views

urlpatterns = [
    path('list/',views.games_list),

]
