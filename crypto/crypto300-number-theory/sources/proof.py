# -- coding: utf-8 --
from time import time
from rnd import getPrime, millerRabin, algP
import random
import binascii


class Generator:
    def __init__(self, seed):
        self.N = 31288934228111896268949411962713065973
        self.fi = 3805352271284257750*8222348943676712722
        self.length = self.bitLen(self.N)
        self.state = seed % self.N

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

    def setOffset(self, seed, offset):
        self.state = pow(seed, pow(2, offset, self.fi), self.N)


if __name__ == "__main__":
    t = time()

    offset = (100408 + 33072) * 8
    check_bytes = '255044462d312e33'.decode('hex')
    check_bytes_enc = 'a56a9699ab90af3c'.decode('hex')

    valid_seed = 0

    for seed in range(32000):
        generator = Generator(seed)
        # generator.getNext(offset)
        generator.setOffset(seed, offset)
        test = ''.join([chr(ord(byte) ^ generator.getNext(8)) for byte in check_bytes_enc])
        if test == check_bytes:
            print("success", seed)
            valid_seed = seed
            break

    print("time={}".format(time()-t))

    if valid_seed:
        with open("flag.enc", 'rb') as f:
            generator = Generator(valid_seed)
            data = f.read()
            gamma = generator.getNext(len(data) * 8)
            with open("flag.tif", 'wb') as w:
                xor = int(data.encode('hex'), 16) ^ gamma
                w.write(hex(xor)[2:-1].decode('hex'))