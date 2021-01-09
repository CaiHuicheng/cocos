#include <dirent.h> 
#include <errno.h> 
/* forward declaration for the iterator function */ 
static int dir_iter (lua_State *L); 

static int l_dir (lua_State *L) { 

	const char *path = luaL_checkstring(L, 1); 
	
	/* create a userdatum to store a DIR address */ 
	DIR **d = (DIR **)lua_newuserdata(L, sizeof(DIR *)); 
	
	/* set its metatable */ 
	luaL_getmetatable(L, "LuaBook.dir"); 
	lua_setmetatable(L, -2); 
	 
	/* try to open the given directory */ 
	*d = opendir(path); 
	
	if (*d == NULL) /* error opening the directory? */
	luaL_error(L, "cannot open %s: %s", path, strerror(errno)); 
	
	
	/* creates and returns the iterator function 
	(its sole upvalue, the directory userdatum, 
	is already on the stack top */
	lua_pushcclosure(L, dir_iter, 1); 
	return 1; 
}

//第二个函数是迭代器：
static int dir_iter (lua_State *L) { 

	DIR *d = *(DIR **)lua_touserdata(L, lua_upvalueindex(1)); 
	struct dirent *entry; 
	
	if ((entry = readdir(d)) != NULL) { 
		lua_pushstring(L, entry->d_name); 
		return 1; 
	} 
	else 
		return 0; /* no more values to return */
}

//__gc 元方法用来关闭目录，但有一点需要小心：因为我们在打开目录之前创建userdatum，所以不管 opendir 的结果是什么，userdatum 将来都会被收集。
static int dir_gc (lua_State *L) { 

	DIR *d = *(DIR **)lua_touserdata(L, 1); 
	if (d) closedir(d); 
	
	return 0; 
}

//最后一个函数打开这个只有一个函数的库：
int luaopen_dir(lua_State *L){
	
	luaL_newmetatable(L, "LuaBook.dir"); 
	
	/* set its __gc field */ 
	lua_pushstring(L, "__gc"); 
	lua_pushcfunction(L, dir_gc); 
	lua_settable(L, -3); 
	
	/* register the `dir' function */ 
	lua_pushcfunction(L, l_dir); 
	lua_setglobal(L, "dir"); 
	
	return 0; 
}