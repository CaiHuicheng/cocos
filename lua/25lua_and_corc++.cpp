/*

Lua堆栈


API有一系列的压栈函数，为了将栈顶的Lua值转换成C值，我们为每种类型定义一个对应的函数：

void lua_pushnil(Lua_State *L);
void lua_pushboolean(Lua_State *L,int bool);
void lua_pushnumber(Lua_State *L,double n);
void lua_pushstring(Lua_State*L,const char*s);
void lua_pushuserdata(Lua_State*L,void*p);

API有一系列的从栈中获取值的函数，为了将栈中的转换C值成Lua值

bool lua_toboolean(Lua_State*L,int idx);
int lua_tonumber(Lua_State*L,int idx);
const char* lua_tostring(Lua_State*L,int idx,size_t *len);
void* lua_touserdata(Lua_State*L,int idx);

Lua API还提供了一套lua_is*来检查一个元素是否是一个指定的类型

int lua_isboolean(Lua_State*L,int idx);
int lua_isnumber(Lua_State*L,int idx);
int lua_isstring(Lua_State*L,int idx);

此外还提供了API函数来人工控制堆栈:

int lua_gettop(luaState *L);
void lua_settop(luaState *L,int idx);
void lua_pushvalue(luaState *L,int idx);
void lua_remove(luaState *L,int idx);
void lua_insert(luaState *L,int idx);
void lua_replace(luaState *L,int idx);



Lua中，对虚拟栈提供正向索引和反向索引两种索引方式，假设当前Lua的栈中有5个元素
 
当C和Lua互相调用的时候，Lua虚拟栈严格的按照LIFO规则操作，只会改变栈顶部分。
但通过Lua的API，可以查询栈上的任何元素，甚至是在任何一个位置插入和删除元素。

*/



#include "lua.hpp"
#include <iostream>
int main()
{
	// 创建一个state
	lua_State *L = luaL_newstate();
	// 入栈
	lua_pushstring(L,"i am testing lua & c++");
	lua_pushnumber(L,123);

	// 读栈取值
	if(lua_isstring(L,-2))  //或if(lua_isstring(L,1))
	{
		std::cout<<lua_tostring(L,-2)<<std::endl;
	}
	if(lua_isnumber(L,-1))
	{
		std::cout<<lua_tonumber(L,-1)<<std::endl;
	}

	//关闭state
	lua_close(L);
	system("pause");
	return 0;
}
