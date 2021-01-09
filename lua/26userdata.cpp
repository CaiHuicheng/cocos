
/*
数组结构
typedef struct NumArray { 
	int size; 
	double values[1]; // variable part 
} NumArray;
使用大小 1 声明数组的 values，由于 C 语言不允许大小为 0 的数组，这个 1 只
是一个占位符；我们在后面定义数组分配空间的实际大小。对于一个有 n 个元素的数组
来说，我们需要
sizeof(NumArray) + (n-1)*sizeof(double) bytes

Lua 中表示数组的值	userdata
void *lua_newuserdata(lua_State *L,size_t,size);
lua_newuserdata 函数按照指定的大小分配一块内存，将对应的 userdatum 放到栈内，
并返回内存块的地址。
*/

//使用 lua_newuserdata 函数，创建新数组的函数实现如下：
static int newarray(lua_State *L){
	int n = luaL_checkint(L,1);
	size_t nbytes = sizeif(NumArray)+(n-1)*sizeof(double);
	NumArray *a = (NumArray *)lua_newuserdata(L,nbytes);
	a->size = n;
	return 1;
}

/*

为了存储元素，我们使用类似 array.set(array, index, value)调用，后面我们将看到如
何使用 metatables 来支持常规的写法 array[index] = value

*/

//方法1
static int setarray(lua_State *L){
	NumArray * a = (NumArray *)lua_touserdata(L,1);
	int index = luaL_checkint(L,2);
	double value = luaL_checknumber(L,3);
	
	luaL_argcheck(L, a != NULL, 1, "`array' expected"); 
	luaL_argcheck(L, 1 <= index && index <= a->size, 2, "index out of range"); 
	a->values[index-1] = value; 
	return 0; 
}

/*

luaL_argcheck 函数检查给定的条件，如果有必要的话抛出错误。因此，如果我们使
用错误的参数调用 setarray，我们将得到一个错误信息：

*/

array.set(a,11,0)
	/* -->  stdin:1: bad argument #1 to 'set' ('array' expected)*/
	
//方法2
static int getarray(lua_State *L){
	NumArray * a = (NumArray *)lua_touserdata(L,1);
	int index = luaL_checkint(L,2);
	
	luaL_argcheck(L, a != NULL, 1, "`array' expected"); 
	luaL_argcheck(L, 1 <= index && index <= a->size, 2, "index out of range"); 
	lua_pushnumber(L, a->values[index-1]); 
	return 1;
}


//获取数组的大小：
static int getsize(lua_State *L){
	
	NumArray *a = (NumArray *)lua_touserdata(L,1);
	
	luaL_argcheck(L, a != NULL, 1, "`array' expected"); 
	
	lua_pushnumber(L, a->size); 
	
	return 1;
}

//需要一些额外的代码来初始化我们的库：

static const struct luaL_reg arraylib [] = { 
 {"new", newarray}, 
 {"set", setarray}, 
 {"get", getarray}, 
 {"size", getsize}, 
 {NULL, NULL} 
}; 
int luaopen_array (lua_State *L) { 
 luaL_openlib(L, "array", arraylib, 0); 
return 1; 
}


