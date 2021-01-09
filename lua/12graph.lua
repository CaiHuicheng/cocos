--[[

	Lua 图 面对对像的实现

--]]

local function name2node( graph,name )
	if not graph[name] then
		--结点不存在，创建一个新的
		graph[name] = {nam = name,adj = {}}
	end
	return graph[name]
end



-->构造一个图。逐行读取一个文件，文件中的每行都有两个结点名称，表示了在两个结点之间有一条边，边的方向从第一个结点到第二个结点
function readgraph()
	local graph = {}
	for line in io.lines() do
		--切分行中的两个名称
		local  namefrom,nameto = string.match(line,"(%S+)%S+(%S+)")
		--查找相应的结点
		local from = name2node(graph,nameform)
		local to = name2node(graph,nameto)
		-- 将‘to’添加到‘from’的邻接集合
		from.adj[to] = true
	end
	return graph
end

-->使用图的算法	采用深度优先的遍历 在两点间搜索一条路径
function findpath( curr,to,path,visited )
	-- body
	path = path or {}
	visited = visited or {}
	if visited[curr] then
		return nil
	end
	visited[curr] = true
	path[#path + 1] = curr
	if curr == to then
		return path
	end
	--尝试所有的邻接节点
	for node in pairs(curr.adj) do
		local p = findpath(node,to,path,visited)
		if p then return p end
	end
	path[#path] = nil
end


-->打印函数
function printpath( path )
	-- body
	for i=1,#path do
		print(path[i].name)
	end
end

g = readgraph()
a = name2node(g,"a")
b = name2node(g,"b")
p = findpath(a,b)
if p then printpath(p) end




