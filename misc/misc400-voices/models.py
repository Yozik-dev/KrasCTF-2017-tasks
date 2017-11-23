import os
import math
from os import path
from datetime import datetime, timedelta
from peewee import *
from pydub import AudioSegment
from spetch import say_something


db = SqliteDatabase('db.db')


class BaseModel(Model):
    class Meta:
        database = db


class Request(BaseModel):
    start_time = DateTimeField()
    text = TextField()
    filename = CharField()

    @staticmethod
    def delete_old():
        curtime = datetime.now()
        old_requests = list(Request.select().where(Request.start_time < (curtime - timedelta(minutes=3))))
        for request in old_requests:
            try:
                os.remove(Request.full_filename(request.filename))
            except OSError:
                pass
        Request.delete().where(Request.start_time < (curtime - timedelta(minutes=3))).execute()

    @staticmethod
    def create_new():
        filename, text = say_something(6)
        result = Request(
            start_time=datetime.now(),
            text=text,
            filename=filename)
        result.save()
        return result

    @staticmethod
    def check_antispam():
        files_list = os.listdir(path.join(path.dirname(path.realpath(__file__)), 'static', 'sounds'))
        return len(files_list) > 1000

    @staticmethod
    def full_filename(filename):
        return path.join(path.dirname(path.realpath(__file__)), 'static', 'sounds', filename+'.mp3')

    def check_expired(self):
        duration = self.get_duration()
        return self.start_time + timedelta(seconds=duration + 2) < datetime.now()

    def get_duration(self):
        audio_file = Request.full_filename(self.filename)
        sound = AudioSegment.from_mp3(audio_file)
        return int(math.ceil(sound.duration_seconds))


if __name__ == '__main__':
    db.connect()
    db.create_tables([Request], safe=True)
    db.close()
