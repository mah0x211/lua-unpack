# lua-unpack

[![test](https://github.com/mah0x211/lua-unpack/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-unpack/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-unpack/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-unpack)

get the elements from the given list.


## Installation

```sh
luarocks install unpack
```


## Usage

```lua
local unpack = require('unpack')
print(unpack({
    'foo',
    hello = 'world',
    'bar',
    nil,
    qux = 'quux',
    nil,
    'baz',
}, 2, 4)) -- 'bar', nil, nil

```
