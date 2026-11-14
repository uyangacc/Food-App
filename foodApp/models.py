from django.db import models

class Recipe(models.Model):
    title = models.CharField(max_length=255, verbose_name="Хоолны нэр")
    description = models.TextField(verbose_name="Тайлбар")
    ingredients = models.TextField(verbose_name="Орц найрлага")
    instructions = models.TextField(verbose_name="Хийх заавар")
    image = models.ImageField(upload_to='recipes/', blank=True, null=True, verbose_name="Зураг")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Үүсгэсэн огноо")

    def __str__(self):
        return self.title