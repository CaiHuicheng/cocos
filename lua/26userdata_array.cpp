/*
	访问数组
	使用传统的写法来访问数组元素a[i]
	 setarray 和 getarray 函数已经依次接受了与他们的元方法对应的参数。一个快速的解
决方法是在我们的 Lua 代码中正确的定义这些元方法：
	
*/

int luaopen_array (lua_State *L) { 
	luaL_newmetatable(L, "LuaBook.array"); 
	luaL_openlib(L, "array", arraylib, 0); 
	
	/* now the stack has the metatable at index 1 and 'array' at index 2 */
	lua_pushstring(L, "__index"); 
	lua_pushstring(L, "get"); 
	 
	lua_gettable(L, 2); /* get array.get */
	lua_settable(L, 1); /* metatable.__index = array.get */
	 
	lua_pushstring(L, "__newindex"); 
	lua_pushstring(L, "set"); 
	 
	lua_gettable(L, 2); /* get array.set */
	lua_settable(L, 1); /* metatable.__newindex = array.set */
	 
	return 0; 
}