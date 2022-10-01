from django.db import models

class Profile (models.Model):
    full_name = models.CharField(max_length=70)

    def __str__(self):
        return self.full_name

class Description(models.Model):
    username = models.CharField(max_length=70)
    email = models.TextField()
    BUID = models.TextField()

    def __str__(self):
        return self.username