import hashlib
def check(a, b):
    if not a.startswith("givemeaflag") or not len(a) == 303:
        return False
    return str(b) == hashlib.md5(str(a)).hexdigest()
