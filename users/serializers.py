from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Favorite


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = User
        fields = ["id", "username", "email", "password"]

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Энэ имэйл бүртгэлтэй байна")
        return value

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class FavoriteSerializer(serializers.ModelSerializer):
    recipe_title = serializers.CharField(source="recipe.title", read_only=True)

    class Meta:
        model = Favorite
        fields = ["id", "recipe", "recipe_title", "created_at"]

    def validate_recipe(self, recipe):
        user = self.context["request"].user
        if Favorite.objects.filter(user=user, recipe=recipe).exists():
            raise serializers.ValidationError("Аль хэдийн дуртай жагсаалтад байна")
        return recipe