from module40289 import check

print("input number and string")
s, hash = raw_input(), str(raw_input())

if check(s, hash):
    print("The valid hash is the flag")
else:
    print("Invalid input")
