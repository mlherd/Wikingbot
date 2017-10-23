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
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
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
        a = "0x84"
        function rightArmUp()
            uart.write(0, tonumber(a), tonumber("0x0F"), tonumber("0x50"), tonumber("0x0F"))
            uart.write(0, tonumber(a), tonumber("0x10"), tonumber("0x58"), tonumber("0x36"))
            uart.write(0, tonumber(a), tonumber("0x11"), tonumber("0x14"), tonumber("0x00"))
        end
        function rightArmDown()
            uart.write(0, tonumber(a), tonumber("0x0F"), tonumber("0x50"), tonumber("0x0F"))
            uart.write(0, tonumber(a), tonumber("0x10"), tonumber("0x20"), tonumber("0x1F"))
            uart.write(0, tonumber(a), tonumber("0x11"), tonumber("0x70"), tonumber("0x2E"))
        end
        function turnWaistLeft()
            uart.write(0, tonumber(a), tonumber("0x03"), tonumber("0x70"), tonumber("0x2E")) --waist
        end
        function turnWaistCenter()
            uart.write(0, tonumber(a), tonumber("0x03"), tonumber("0x44"), tonumber("0x26")) --waist
        end
        function turnWaistRight()
            uart.write(0, tonumber(a), tonumber("0x03"), tonumber("0x00"), tonumber("0x1E")) --waist
        end
        client:send("HTTP/1.1 200 OK\n\n");
        client:send("<!DOCTYPE HTML>");
        client:send("<html>");
        client:send("</html>");
        client:send("<p> <a href=\"?Id=1\"><button>Right Arm Up</button></a> </p>");
        client:send("<p> <a href=\"?Id=2\"><button>Right Arm Down</button></a></p>");
        client:send("<p> <a href=\"?Id=3\"><button>Turn Left</button></a></p>");
        client:send("<p> <a href=\"?Id=4\"><button>Turn Right</button></a></p>");
        client:send("<p> <a href=\"?Id=5\"><button>Turn Center</button></a></p>");
        local _on,_off = "",""
        if(_GET.dId == "1")then
            rightArmUp()
        elseif(_GET.Id == "2")then
            rightArmDown()
        elseif(_GET.Id == "3")then
            turnWaistLeft()
        elseif(_GET.Id == "4")then
            turnWaistRight()
        elseif(_GET.Id == "5")then
            turnWaistCenter()
        end
        client:close();
        collectgarbage();
    end)
end)