from django.contrib import admin
from .models import Category, Difficulty, MealType, Recipe

admin.site.register(Category)
admin.site.register(Difficulty)
admin.site.register(MealType)
admin.site.register(Recipe)