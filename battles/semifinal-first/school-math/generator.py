import random

flag = 'you are so amazing! Keep trying. Well. Almost. Done. Okay, here is your flag: kctf{goandstudymath}'

for c in flag:
    x = ord(c)
    if random.getrandbits(1):
        a = random.randint(-100, 100)
        b = -a * x
        if b > 0:
            print("{}x + {} = 0".format(a, b))
        else:
            print("{}x - {} = 0".format(a, -b))
    else:
        a = random.randint(-10, 10)
        b = random.randint(-100, 100)
        c = -a * x**2 - b * x
        astr = str(a)
        bstr = "- " + str(-b) if b < 0 else "+ " + str(b)
        cstr = "- " + str(-c) if c < 0 else "+ " + str(c)

        print("{}x^2 {}x {} = 0".format(astr, bstr, cstr))