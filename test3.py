import traceback

def outer(x: int, y, *args) -> dict:
    def inner(a, b:str) -> tuple:
        print("Hello from inner")
    print("Hello from outer")
    inner(x, y)

outer(1, "2", 3)
try:
    outer(1, 2)
except Exception as ex:
    traceback.print_exc()

try:
    outer("1", 2)
except Exception as ex:
    traceback.print_exc()
