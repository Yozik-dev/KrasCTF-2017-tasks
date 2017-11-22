# -- coding: utf-8 --
from rnd import getPrime, millerRabin, algP
import random
import binascii


class Generator:
    def __init__(self, bits):
        self.N = 31288934228111896268949411962713065973
        self.length = self.bitLen(self.N)
        seed = 31107  # random.getrandbits(self.length)
        self.state = seed % self.N

    def generateSequenceOfBits(self, bits):
        while True:
            p = getPrime(bits)
            if p & 3 == 3:
                return p

    def generateN(self, bits):
        p = self.generateSequenceOfBits(bits / 2)
        while 1:
            q = self.generateSequenceOfBits(bits / 2)
            if p != q:
                return p * q

    def bitLen(self, x):
        assert x > 0
        q = 0
        while x:
            q += 1
            x >>= 1
        return q

    def getNext(self, bits):
        result = 0
        for i in xrange(bits):
            self.state = (self.state ** 2) % self.N
            result = (result << 1) | (self.state & 1)

        return result


class Encryptator:

    def __init__(self):
        self.obj = Generator(128)

    def encrypt(self, filename, output):
        with open(filename, 'rb') as f:
            data = f.read()
            gamma = self.obj.getNext(len(data) * 8)
            with open(output, 'wb') as w:
                xor = int(data.encode('hex'), 16) ^ gamma
                w.write(hex(xor)[2:-1].decode('hex'))

    def encrypt_files(self, files):
        for filename in files:
            self.encrypt(filename, filename + ".enc")

if __name__ == '__main__':
    e = Encryptator()
    e.encrypt_files(["flag", "document.png", "FaceID_Security_Guide.pdf"])
