/*

访问面向对象的数据

下面我们来看看如何定义类型为对象的 userdata，以致我们就可以使用面向对象的
语法来操作对象的实例，比如：
a = array.new(1000) 
print(a:size()) --> 1000 
a:set(10, 3.4) 
print(a:get(10)) --> 3.4

*/

/*

现在数组是对象，他
有自己的操作，我们在表数组中不需要这些操作。我们实现的库唯一需要对外提供的函
数就是 new，用来创建一个新的数组。所有其他的操作作为方法实现。C 代码可以直接
注册他们。
getsize、getarray 和 setarray 与我们前面的实现一样，不需要改变。我们需要改变的
只是如何注册他们。也就是说，我们必须改变打开库的函数。首先，我们需要分离函数
列表，一个作为普通函数，一个作为方法：

*/

static const struct luaL_reg arraylib_f [] = { 

	{"new", newarray}, 
	
	{NULL, NULL} 
	
}; 


static const struct luaL_reg arraylib_m [] = { 

	{"set", setarray}, 
	{"get", getarray}, 
	{"size", getsize}, 
	{NULL, NULL} 
	
};

/*
新版本打开库的函数 luaopen_array，必须创建一个 metatable，并将其赋值给自己的
__index 域，在那儿注册所有的方法，创建并填充数组表：

*/
int luaopen_array (lua_State *L) { 

	luaL_newmetatable(L, "LuaBook.array"); 
	lua_pushstring(L, "__index"); 
	lua_pushvalue(L, -2); /* pushes the metatable */
	lua_settable(L, -3); /* metatable.__index = metatable */

	luaL_openlib(L, NULL, arraylib_m, 0); 
	luaL_openlib(L, "array", arraylib_f, 0); 
	return 1; 
}

//新类型添加一个__tostring 方法，这样一来 print(a)将打印数组加上数组的大小，大小两边带有圆括号（比如，array(1000)）：
int array2string (lua_State *L) { 
	NumArray *a = checkarray(L); 
	lua_pushfstring(L, "array(%d)", a->size); 
	return 1; 
}

/*
函数 lua_pushfstring 格式化字符串，并将其放到栈顶。为了在数组对象的 metatable
中包含 array2string，我们还必须在 arraylib_m 列表中添加 array2string：
*/
static const struct luaL_reg arraylib_m [] = { 
	 {"__tostring", array2string}, 
	 {"set", setarray}, 
	 ... 
};

