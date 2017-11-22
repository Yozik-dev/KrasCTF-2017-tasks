import random

p, q = 11, 19
n = p * q
fi = (p-1) * (q-1)
assert p % 4 == 3
assert q % 4 == 3

def long_calc(seed, index):
    for i in range(index):
        seed = (seed ** 2) % n
    return seed

def short_calc(seed, index):
    return pow(seed, pow(2, index, fi), n)
    
def test():
    for i in range(100):
        seed = random.randint(1, 10000)
        index = random.randint(1, 10000)
        assert long_calc(seed, index) == short_calc(seed, index)

#test()

seed = 1337
res = short_calc(seed, 10**8)
print(res)

