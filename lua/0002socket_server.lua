
--lua的TCP通信发送字符串末尾必须添加\n
--server
socket = require("socket")  --调用socket包
ip = "127.0.0.1" --程序设置自己为Server端，设置自己的ip地址
port = 8080 --设置端口
 
server = assert(socket.bind(ip, port))  --按照上面的参数开启服务器
 
ack = "ack\n"
while 1 do
    print("server: waiting for client connection...")
    control = assert(server:accept())   --等待客户端的连接，因此这个程序只能同时连接一个TCP客户端设备
    while 1 do
        command, status = control:receive() --等待字符信号发送过来
        if command == "closed" then
            break
        end
        if command ~= nil then
            print(command)
            control:send(ack)
        end
    end
end