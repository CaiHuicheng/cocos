local metaarray = getmetatable(array.new(1)) 
metaarray.__index = metaarray 
metaarray.set = array.set 
metaarray.get = array.get 
metaarray.size = array.size