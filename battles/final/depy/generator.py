import random

a = 5
for i in range(100):
    b = random.randint(6, 100000)
    r = random.randint(0, 1000)
    with open("module" + str(b) + ".py", "w") as w:
        w.write("""
from module"""+str(a)+""" import check as check1
def check(a, b):
    return check1(a+str("""+str(r)+"""), b)
        """)
    a = b
print(a)