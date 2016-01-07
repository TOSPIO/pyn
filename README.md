# Pyn
Python 2.7 with annotations


## Current status

### Can only be used to prettify Pyn source code :(

Given:

```python
class Qaslkdjfenurbasdfkjalsrke(object): pass
def g(a: Qaslkdjfenurbasdfkjalsrke, b: Qaslkdjfenurbasdfkjalsrke) -> int: pass
class Goddamn(object):
    __metaclass=                           type
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
def g(a:Qaslkdjfenurbasdfkjalsrke , b:Qaslkdjfenurbasdfkjalsrke ) -> int:
    pass
class Goddamn(object):
    __metaclass = type
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


## Acknowledgements

Many thanks to [language-python](https://github.com/bjpop/language-python) project by @bjpop
