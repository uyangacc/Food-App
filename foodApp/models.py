from django.db import models

class Recipe(models.Model):
    Нэр = models.CharField(max_length=255, verbose_name="Хоолны нэр")
    Тайлбар= models.TextField(verbose_name="Тайлбар")
    Найрлага = models.TextField(verbose_name="Орц найрлага")
    Заавар = models.TextField(verbose_name="Хийх заавар")
    Зураг = models.ImageField(upload_to='recipes/', blank=True, null=True, verbose_name="Зураг")
    Огноо = models.DateTimeField(auto_now_add=True, verbose_name="Үүсгэсэн огноо")
    Хугацаа = models.CharField(max_length=50, blank=True, null=True, verbose_name="Хийх хугацаа")
    Порц = models.PositiveIntegerField(default=2, verbose_name="Хүний тоо / Порц")

    def __str__(self):
        return f"{self.Нэр}"