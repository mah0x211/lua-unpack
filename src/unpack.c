/**
 *  Copyright (C) 2022 Masatoshi Fukunaga
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to
 *  deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 *  sell copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 *  IN THE SOFTWARE.
 *
 */

#include <lauxhlib.h>
#include <lua.h>

static int unpack_lua(lua_State *L)
{
    lua_Integer i  = 0;
    lua_Integer e  = 0;
    unsigned int n = 0;

    lauxh_checktable(L, 1);
    i = lauxh_optinteger(L, 2, 1);
    e = lauxh_optinteger(L, 3, lauxh_rawlen(L, 1));

#if defined(LUA_LJDIR)
    if (lua_isnoneornil(L, 3)) {
        lua_State *th = lua_newthread(L);

        lua_insert(L, 1);
        lua_settop(L, 2);
        lua_pushnil(L);
        while (lua_next(L, 2)) {
            if (lauxh_isinteger(L, -2)) {
                int top         = lua_gettop(th);
                lua_Integer idx = lua_tointeger(L, -2);

                // ignore smaller than i
                if (idx < i) {
                    lua_pop(L, 1);
                    continue;
                }
                idx = idx - i + 1;

                if (idx > top && !lua_checkstack(th, idx - top)) {
                    return luaL_error(L, "too many results to unpack");
                } else if (idx < top) {
                    lua_xmove(L, th, 1);
                    lua_insert(th, idx);
                    continue;
                }

                for (int j = top + 1; j < idx; j++) {
                    lua_pushnil(th);
                }
                lua_xmove(L, th, 1);
                continue;
            }
            lua_pop(L, 1);
        }
        lua_settop(L, 1);
        n = lua_gettop(th);
        if (!lua_checkstack(L, n)) {
            return luaL_error(L, "too many results to unpack");
        }
        lua_xmove(th, L, n);
        return (int)n;
    }
#endif

    if (e < i) {
        return 0;
    }

    lua_settop(L, 1);
    n = (unsigned int)e - i;
    if (n >= INT_MAX || !lua_checkstack(L, (int)(++n))) {
        return luaL_error(L, "too many results to unpack");
    }
    for (; i <= e; i++) {
        lua_rawgeti(L, 1, i);
    }

    return (int)n;
}

LUALIB_API int luaopen_unpack(lua_State *L)
{
    lua_pushcfunction(L, unpack_lua);
    return 1;
}
