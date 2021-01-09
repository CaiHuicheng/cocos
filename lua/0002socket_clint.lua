--lua的TCP通信发送字符串末尾必须添加\n
--client
socket = require("socket")  --调用socket包
ip = "127.0.0.1"    --程序设置要了解的server端的ip地址
port = 8080 --设置端口
 
c = assert(socket.connect(ip, port))    --根据上边的参数连接server端，若未连接上直接报错
 
c:send("GET\n") --首先发送一个信号
 
while 1 do
    s, status, partial = c:receive()    --等待服务器发送过来的信号
    print(s)
    if status == "closed" then 
        break
    end
    str_send = io.read()    --等待输入要发送出去的信号
    str_send = str_send..'\n'
    c:send(str_send)
end
 
c:close()