/*
防止 core dump

为了区分数组和其他的userdata，我们单独为数组创建了一个metatable（记住userdata
也可以拥有 metatables）。下面，我们每次创建一个新的数组的时候，我们将这个单独的
metatable 标记为数组的 metatable。每次我们访问数组的时候，我们都要检查他是否有一
个正确的 metatable。因为 Lua 代码不能改变 userdatum 的 metatable，所以他不会伪造我
们的代码

我们还需要一个地方来保存这个新的 metatable，这样我们才能够当创建新数组和检
查一个给定的 userdatum 是否是一个数组的时候，可以访问这个 metatable。正如我们前
面介绍过的，有两种方法可以保存 metatable：在 registry 中，或者在库中作为函数的
upvalue。在 Lua 中一般习惯于在 registry 中注册新的 C 类型，使用类型名作为索引，
metatable 作为值。和其他的 registry 中的索引一样，我们必须选择一个唯一的类型名，
避免冲突。我们将这个新的类型称为 "LuaBook.array

	辅助库提供了一些函数来帮助我们解决问题，我们这儿将用到的前面未提到的辅助
函数有：
	int luaL_newmetatable (lua_State *L, const char *tname); 
	void luaL_getmetatable (lua_State *L, const char *tname); 
	void *luaL_checkudata (lua_State *L, int index, const char *tname);


*/

//metatable table
int luaopen_array (lua_State *L) { 

	luaL_newmetatable(L, "LuaBook.array"); 
	luaL_openlib(L, "array", arraylib, 0); 
	
	return 1; 
}

//修改 newarray，使得在创建数组的时候设置数组的 metatable：
static int newarray (lua_State *L) { 

	int n = luaL_checkint(L, 1); 
	size_t nbytes = sizeof(NumArray) + (n - 1)*sizeof(double); 
	
	NumArray *a = (NumArray *)lua_newuserdata(L, nbytes); 
	luaL_getmetatable(L, "LuaBook.array"); 
	lua_setmetatable(L, -2); 
	a->size = n; 
	
	return 1; /* new userdatum is already on the stack */
}

//最后一步，setarray、getarray 和 getsize 检查他们的第一个参数是否是一个有效的数组。
static int getsize (lua_State *L) { 
	NumArray *a = checkarray(L); 
	lua_pushnumber(L, a->size); 
	return 1; 
}

//由于 setarray 和 getarray 检查第二个参数 index 的代码相同，我们抽象出他们的共同部分，在一个单独的函数中完成：
static double *getelem (lua_State *L) {
	
	int index = luaL_checkint(L, 2); 
	
	luaL_argcheck(L, 1 <= index && index <= a->size, 2, "index out of range"); 
	
	/* return element address */ 
	return &a->values[index - 1]; 
}

//使用这个 getelem，函数 setarray 和 getarray 更加直观易懂：
static int setarray (lua_State *L) { 

	double newvalue = luaL_checknumber(L, 3); 
	*getelem(L) = newvalue; 
	
	return 0; 
} 
static int getarray (lua_State *L) { 

	lua_pushnumber(L, *getelem(L)); 
	
	return 1; 
}

/*

尝试 array.get(io.stdin, 10)的代码，你将会得到正确的错误信息：
error: bad argument #1 to 'getarray' ('array' expected)

*/
