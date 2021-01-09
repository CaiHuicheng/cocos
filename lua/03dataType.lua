--nil		->	null
--boolean 	->	true or false
--number	->	double
--string	->	string "" or ''
--function  ->	函数(c/lua)		要以end结尾
--userdata	->  存储在变量中的C数据结构
--thread	->	线程
--table		-> 	表->关联数组

print(type("string"))	-->string
print(type(10.4*3))		-->number
print(type(print))		-->function
print(type(type))		-->function
print(type(true))		-->boolean
print(type(nil))		-->null
print(type(type(X)))	-->string