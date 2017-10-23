tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      tmr.stop(0)
   end
end)


--protocol= 0XAA
--device_number 
--0x04
--channel_number 
--target_lowbits
--target_highbits


-- in decimal 132, 2, 112, 46
protocol = "0x84"

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        
        buf = buf.."HTTP/1.1 200 OK\n\n";
        buf = buf.."<!DOCTYPE HTML>";
        buf = buf.."<html>";
        buf = buf.."<p> <a href=\"?servoId=0\"><button>ResetBot</button></a></p>";
        buf = buf.."<p> <a href=\"?servoId=1\"><button>Servo 1</button></a>";
        buf = buf.."<p> <a href=\"?servoId=2\"><button>Servo 2</button></a>";
        buf = buf.."<p> <a href=\"?servoId=3\"><button>Servo 3</button></a>";
        buf = buf.."<p> <a href=\"?servoId=4\"><button>Servo 4</button></a>";
        buf = buf.."</html>";
        local _on,_off = "",""
        
        if(_GET.servoId == "1")then
            uart.write(0, tonumber("0x84"), tonumber("0x02"), tonumber("0x70"), tonumber("0x2E"))
        elseif(_GET.serviId == "4")then
            uart.write(0, 0x84, 0x02, 0x70, 0x2E)
        elseif(_GET.serviId == "3")then
            uart.write(0, '0x84', '0x02', '0x70', '0x2E')
        elseif(_GET.serviId == "2")then
            uart.write(0, "0x84", "0x02", "0x70", "0x2E")
        end
        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
