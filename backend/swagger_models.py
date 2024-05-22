from django.urls import path
from rest_framework import permissions
from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from drf_yasg.generators import OpenAPISchemaGenerator
from api.models import Chat



class CustomSchemaGenerator(OpenAPISchemaGenerator):
    def get_schema(self, request=None, public=False):
        schema = super().get_schema(request, public)

        # Define the schema for the Book model
        book_schema = openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'id': openapi.Schema(type=openapi.TYPE_INTEGER),
                'title': openapi.Schema(type=openapi.TYPE_STRING),
                'author': openapi.Schema(type=openapi.TYPE_STRING),
                'published_date': openapi.Schema(type=openapi.TYPE_STRING, format=openapi.FORMAT_DATE)
            }
        )

        # Add the Book schema to the definitions section of the schema
        schema.components._components['schemas']['Book'] = book_schema

        return schema
