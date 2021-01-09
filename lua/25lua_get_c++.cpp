/*
Lua 调用 C++

步骤： 
1. 将C的函数包装成Lua环境认可的函数 
2. 将包装好的函数注册到Lua环境中 
3. 像使用普通Lua函数那样使用注册函数
包装C函数
为了从Lua脚本中调用C函数，需要将被调用的C函数从普通的C函数包装成Lua_CFunction格式，
并需要在函数中将返回值压入栈中，并返回返回值个数：
 int (lua_CFunction*)(lua_state*){
	 //c code				// 实现逻辑功能
	 // lua_pu+sh code		// 需要将返回值压入堆栈
	 return n;				// n为具体的返回值个数，告诉解释器，函数向堆栈压入几个返回值
 }
 
 
 例如
int add(int a,int b)
{
    return a+b;
}


int add(lua_state*L)
{
	int a = lua_tonumber(-1);
	int b = lua_tonumber(-2);
	int sum = a +ｂ;
	lua_pushnumber(L,sum);
	return a;
}

注册C函数到Lua环境
将函数压栈，然后给函数设置一个在Lua中调用的名称
	lua_register(L,n,f);

lua_register是一个宏，对应两个函数:lua_pushfunction(L,f)和lua_setglobal(L,n)，将函数存放在一个全局table中。
lua_register(L,"Add2Number",add);

使用注册函数
像使用普通函数一样使用注册函数

Add2Number(1,2);

示例
test.lua

print("Hi! " .. sayHi("xchen"))

*/
#include "lua.hpp"
#include <iostream>
using namespace std;
//C++中定义、实现函数sayHi
int sayHi(lua_State *L)
{
    //获取lua函数中的第一个参数
    string name = luaL_checkstring(L,1);
    //压栈
    lua_pushstring(L,name.data());
    return 1;
}
int main()
{
    //创建一个state
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
 
    //为Lua注册名为第一个参数的函数，实际上是调用c++中第三个参数名的函数
    lua_register(L, "sayHi" ,sayHi);
 
    //读lua文件并运行Lua code
    int fret = luaL_dofile(L,"test.lua");
    if(fret)
    {
        std::cout<<"read lua file error!"<<std::endl;
    }
 
    //关闭state
    lua_close(L);
    return 0;
}


