import random
from hashlib import md5
from gtts import gTTS


def say_something(lines_count):
    from models import Request
    all_lines = open('texts.txt').read().splitlines()
    random.shuffle(all_lines)
    text = '. '.join(all_lines[:lines_count])
    print text
    tts = gTTS(text=text, lang='en')
    result = md5(text).hexdigest()
    filename = Request.full_filename(result)
    tts.save(filename)
    return result, text
