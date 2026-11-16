from rest_framework import serializers, viewsets, permissions
from foodApp.models import Category, Difficulty, MealType


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name"]


class DifficultySerializer(serializers.ModelSerializer):
    class Meta:
        model = Difficulty
        fields = ["id", "name"]


class MealTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealType
        fields = ["id", "name"]


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]


class DifficultyViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Difficulty.objects.all()
    serializer_class = DifficultySerializer
    permission_classes = [permissions.AllowAny]


class MealTypeViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MealType.objects.all()
    serializer_class = MealTypeSerializer
    permission_classes = [permissions.AllowAny]