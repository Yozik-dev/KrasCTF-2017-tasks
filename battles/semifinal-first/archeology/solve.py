import zipfile

zip_ref = zipfile.ZipFile("task.zip", 'r')

for a in range(255):
    for b in range(255):
        password = chr(a) + chr(b)
        try:
            zip_ref.extractall(pwd=password)
            with open("task.txt") as f:
                message = f.read()
                if "flag is" in message:
                    print(message)
        except:
            pass
zip_ref.close()
