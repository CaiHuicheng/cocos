/*

Lua��ջ


API��һϵ�е�ѹջ������Ϊ�˽�ջ����Luaֵת����Cֵ������Ϊÿ�����Ͷ���һ����Ӧ�ĺ�����

void lua_pushnil(Lua_State *L);
void lua_pushboolean(Lua_State *L,int bool);
void lua_pushnumber(Lua_State *L,double n);
void lua_pushstring(Lua_State*L,const char*s);
void lua_pushuserdata(Lua_State*L,void*p);

API��һϵ�еĴ�ջ�л�ȡֵ�ĺ�����Ϊ�˽�ջ�е�ת��Cֵ��Luaֵ

bool lua_toboolean(Lua_State*L,int idx);
int lua_tonumber(Lua_State*L,int idx);
const char* lua_tostring(Lua_State*L,int idx,size_t *len);
void* lua_touserdata(Lua_State*L,int idx);

Lua API���ṩ��һ��lua_is*�����һ��Ԫ���Ƿ���һ��ָ��������

int lua_isboolean(Lua_State*L,int idx);
int lua_isnumber(Lua_State*L,int idx);
int lua_isstring(Lua_State*L,int idx);

���⻹�ṩ��API�������˹����ƶ�ջ:

int lua_gettop(luaState *L);
void lua_settop(luaState *L,int idx);
void lua_pushvalue(luaState *L,int idx);
void lua_remove(luaState *L,int idx);
void lua_insert(luaState *L,int idx);
void lua_replace(luaState *L,int idx);



Lua�У�������ջ�ṩ���������ͷ�����������������ʽ�����赱ǰLua��ջ����5��Ԫ��
 
��C��Lua������õ�ʱ��Lua����ջ�ϸ�İ���LIFO���������ֻ��ı�ջ�����֡�
��ͨ��Lua��API�����Բ�ѯջ�ϵ��κ�Ԫ�أ����������κ�һ��λ�ò����ɾ��Ԫ�ء�

*/



#include "lua.hpp"
#include <iostream>
int main()
{
	// ����һ��state
	lua_State *L = luaL_newstate();
	// ��ջ
	lua_pushstring(L,"i am testing lua & c++");
	lua_pushnumber(L,123);

	// ��ջȡֵ
	if(lua_isstring(L,-2))  //��if(lua_isstring(L,1))
	{
		std::cout<<lua_tostring(L,-2)<<std::endl;
	}
	if(lua_isnumber(L,-1))
	{
		std::cout<<lua_tonumber(L,-1)<<std::endl;
	}

	//�ر�state
	lua_close(L);
	system("pause");
	return 0;
}
