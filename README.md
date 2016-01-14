# Pyn
[![Build Status](https://travis-ci.org/TOSPIO/pyn.svg?branch=master)](https://travis-ci.org/TOSPIO/pyn)

Python 2.7 with annotations support

## Travis CI

| Branch | Status |
| ------ | ------ |
| master | [![Build Status](https://travis-ci.org/TOSPIO/pyn.svg?branch=master)](https://travis-ci.org/TOSPIO/pyn) |
| dev    | [![Build Status](https://travis-ci.org/TOSPIO/pyn.svg?branch=dev)](https://travis-ci.org/TOSPIO/pyn) |

## Current status

### ~~Can only be used to prettify Pyn source code :(~~

Given:

```python
class Qaslkdjfenurbasdfkjalsrke(object): pass
def g(a: Qaslkdjfenurbasdfkjalsrke, b: Qaslkdjfenurbasdfkjalsrke  = 100) -> int: pass
class Goddamn(object):
    __metaclass__=                           type
    @staticmethod
    def        u              (a       ,  b       ):
            if a     < b: return       b-    a
            else:
             return a  -b




class Hey(Goddamn, Qaslkdjfenurbasdfkjalsrke):      pass

print "Hello world";      print("Hello world")
```

Outputs:

```python
class Qaslkdjfenurbasdfkjalsrke(object):
    pass
def g(a:Qaslkdjfenurbasdfkjalsrke , b:Qaslkdjfenurbasdfkjalsrke =100) -> int:
    pass
class Goddamn(object):
    __metaclass__ = type
    @staticmethod
    def u(a, b):
        if a < b:
            return b - a
        else:
            return a - b
class Hey(Goddamn, Qaslkdjfenurbasdfkjalsrke):
    pass

print "Hello world"
print ("Hello world")
```

As a formatter it's far from being perfect.

Not what it's supposed to act as though :)

# Now it can generate basic typecheck code

Given:

```python
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
```

Outputs:
```python
import traceback
def outer(x, y, *args):
    if not isinstance(x, int):
        raise TypeError("x must be of type int")
    def inner(a, b):
        if not isinstance(b, str):
            raise TypeError("b must be of type str")
        print ("Hello from inner")
    print ("Hello from outer")
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
```

Pipelined to Python 2.7 interpreter:
```bash
$ dist/build/pyn/pyn test3.py | python
Hello from outer
Hello from inner
Hello from outer
Traceback (most recent call last):
  File "<stdin>", line 13, in <module>
  File "<stdin>", line 10, in outer
  File "<stdin>", line 7, in inner
TypeError: b must be of type str
Traceback (most recent call last):
  File "<stdin>", line 17, in <module>
  File "<stdin>", line 4, in outer
TypeError: x must be of type int
$
```

## Acknowledgements

Many thanks to [language-python](https://github.com/bjpop/language-python) project by @bjpop
