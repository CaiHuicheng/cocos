function DeepCopy(object)      
    local SearchTable = {}  
 
    local function Func(object)  
        if type(object) ~= "table" then  
            return object         
        end  
        local NewTable = {}  
        SearchTable[object] = NewTable  
        for k, v in pairs(object) do  
            NewTable[Func(k)] = Func(v)  
        end     
       
        return setmetatable(NewTable, getmetatable(object))      
    end    
  
    return Func(object)  
end   