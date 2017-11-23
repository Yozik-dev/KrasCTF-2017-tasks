import Levenshtein
import speech_recognition as sr
from pydub import AudioSegment

from os import path


def recognize_file(number):
    audio_file = path.join(path.dirname(path.realpath(__file__)), 'static', 'sounds', number+'.mp3')

    sound = AudioSegment.from_mp3(audio_file)
    audio_file = path.join(path.dirname(path.realpath(__file__)), "temp.wav")
    sound.export(audio_file, format="wav")

    r = sr.Recognizer()
    with sr.AudioFile("temp.wav") as source:
        audio = r.record(source)
        return unicode(r.recognize_google(audio))


def clear_text(text):
    text = text.lower()
    text = text.replace(',', '')
    text = text.replace('.', '')
    text = text.replace('?', '')
    text = text.replace('!', '')
    text = text.replace('(', '')
    text = text.replace(')', '')
    return text


def check_texts(original, variant):
    original = clear_text(original)
    variant = clear_text(variant)
    ratio = Levenshtein.ratio(original, variant)
    print ratio
    return ratio > 0.87



if __name__ == '__main__':
    # recognize_file('1')
    a = u"I wish I was, fucking oath mate, let me sleep!. Spending all my time running these empty fucking streets. So wat if i gave it to you. I'm on my knees, please help me stay alive. I'm becoming afraid, it's already to late. Am i losing my mind (wasting time)"
    b = recognize_file('1')
    print b
    check_texts(a, b)