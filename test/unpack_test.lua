local testcase = require('testcase')
local unpack = require('unpack')

function testcase.unpack()
    -- test that returns the elements of the given list
    assert.equal({
        unpack({
            'foo',
            hello = 'world',
            'bar',
            nil,
            qux = 'quux',
            nil,
            'baz',
        }),
    }, {
        'foo',
        'bar',
        nil,
        nil,
        'baz',
    })

    -- test that returns the 2nd and subsequent elements of a given list
    assert.equal({
        unpack({
            'foo',
            hello = 'world',
            'bar',
            nil,
            qux = 'quux',
            nil,
            'baz',
        }, 2),
    }, {
        'bar',
        nil,
        nil,
        'baz',
    })

    -- test that returns the 2nd to 4th elements of a given list
    assert.equal({
        unpack({
            'foo',
            hello = 'world',
            'bar',
            nil,
            qux = 'quux',
            nil,
            'baz',
        }, 2, 4),
    }, {
        'bar',
        nil,
        nil,
    })

    -- test that return no elements
    assert.empty({
        unpack({
            'foo',
            hello = 'world',
            'bar',
            nil,
            qux = 'quux',
            nil,
            'baz',
        }, 2, 1),
    })
end
