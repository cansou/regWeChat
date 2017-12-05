--解锁手机
function unlock_phone()
	if deviceIsLock()~=0 then
		unlockDevice(); 
	end
end

--按Home键，回到主屏幕；
function press_home()
	pressHomeKey(0);
	pressHomeKey(1);
	mSleep(1000);
end

--获取设备宽高函数
function get_device_size()
	return getScreenSize();
end

--*****************点击指定坐标函数
function click_point(x,y,sleep_time)
	touchDown(x, y);
	mSleep(100);
	touchUp(x, y);
	mSleep(sleep_time or 2000);
	
end

--点击从一个点移动到另一个点
function move_to(x1,y1,x2,y2,step)
	moveTo(x1,y1,x2,y2,step)
end

--打开/关闭VPN函数模块，依赖已截取的四张图片
--preferences_VPN_connected.png --VPN开关已打开时的截图
--preferences_VPN_disconnected.png --VPN开关未打开时的截图
--VPN_connection_failed.png --VPN链接失败提示弹框图
--VPN_connection_failed_OK_button.png --VPN链接失败弹出框（好）字按钮图
function open_VPN()
	runApp("com.apple.Preferences");--启动“设置”
	mSleep(2000);
	
	local deviceX,deviceY = getScreenSize();
	local x, y = findImage("preferences_VPN_disconnected.png", 0, 0, deviceX, deviceY);
	if (x ~= -1 and y ~= -1) then
		while (true) do
			VPN_connected = false;
			touchDown(4, 650, y+20);
			mSleep(67);
			touchUp(4, 650, y+20);
			mSleep(5000);
			for num = 1, 300 do
				x1, y1 = findImage("VPN_connection_failed.png", 0, 0, deviceX, deviceY);
				if (x1 ~= -1 and y1 ~= -1) then
					x2, y2 = findImage("VPN_connection_failed_OK_button.png", 0, 0, deviceX, deviceY); 
					if (x2 ~= -1 and y2 ~= -1) then
						touchDown(6, x2+20, y2+15);
						mSleep(67);
						touchUp(6, x2+20, y2+15);
						mSleep(500);
						break;
					end
				end
				x1, y1 = findImage("preferences_VPN_connected.png", 0, 0, deviceX, deviceY);
				if (x1 ~= -1 and y1 ~= -1) then
					VPN_connected = true;
					break;
				end
			end
			if (VPN_connected == true) then
				break;
			else
				mSleep(1000);
			end
		end
	end
end

function close_VPN()
	runApp("NZT");--启动“设置”
	mSleep(2000);
	
	local deviceX,deviceY = getScreenSize();
	local x, y = findImage("preferences_VPN_connected.png", 0, 0, deviceX, deviceY);
	if (x ~= -1 and y ~= -1 ) then
		touchDown(4, 650, y+20);
		mSleep(67);
		touchUp(4, 650, y+20);
		mSleep(1000);
	end
end

--输出日志并启动运行lua程序
function log_and_restart(message)
--	close_VPN();
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " "  .. "Try to restart: " .. message);
	closeLog(logFileName);
	pressHomeKey(0);
	pressHomeKey(1);
	mSleep(1000);
	lua_restart();
end

--输出日志并退出运行lua程序
function log_and_exit(message)
--	close_VPN();
	nLog(message)
	snapshot(os.date("%Y-%m-%d%H:%M:%S").."_unknow.png", 0, 0, 749, 1330);
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " "  .. "Exit: " .. message);
	closeLog(logFileName);
	mSleep(1000);
	lua_exit();
end

--运行APP函数
function run_app(bid,sleep_time)
	local flag = appIsRunning(bid); --检测APP是否在运行
	if flag  == 1 then              --如果在运行就先关闭
		closeApp(bid);
		mSleep(1000)
	end
	runApp(bid);
	mSleep(sleep_time or 1000);
end

--退出APP函数
function close_app(bid,sleep_time)
	closeApp(bid);
	mSleep(sleep_time or 50);
end

--***************运行NZT一键新机并退回主屏幕
function to_reset_phone()
	runApp("NZT");				--运行NZT
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " "  .. "启动一键新机重置手机");
	mSleep(3000);				--等待NZT启动完成
	touchDown(6, 488, 822);		--点击一键新机；
	mSleep(67);
	touchUp(6, 488, 822);
	mSleep(8000);				--等待一键新机完成
	pressHomeKey(0);			--按Home键，回到主屏幕；
	pressHomeKey(1);
	mSleep(1000);
end

--***************运行iG-R8一键新机并退回主屏幕
function use_iGR8_to_reset_phone()
	runApp("com.unkn0wn.R8");	--运行iG
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " "  .. "启动一键新机重置手机");
	mSleep(3000);				--等待iG启动完成
	touchDown(6, 637, 926);		--点击一键新机；
	mSleep(67);
	touchUp(6, 640, 929);
	mSleep(6000);				--等待一键新机完成
	pressHomeKey(0);			--按Home键，回到主屏幕；
	pressHomeKey(1);
	mSleep(1000);
end

--***************重启关闭飞行模式
function toggle_airModel()
	setAirplaneMode(true);--打开飞行模式；
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " "  .. "重启打开并关闭飞行模式");
	mSleep(5000);--停顿5秒；
	setAirplaneMode(false);--关闭飞行模式
	mSleep(5000);
end


--全屏区域内查找指定图片
function find_image(imageName,count,callBack)
	local w,h = getScreenSize();
	for num = 1, count do
		x, y = findImage(imageName, 0, 0, w-1, h-1);
		if (x ~= -1 and y ~= -1) then
			mSleep(1000);
			touchDown(3, 510, 765);--在确认短信发送界面点击“好”；
			mSleep(135);
			touchUp(3, 510, 765);
			mSleep(500);
			break;
		else
			wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. "没有找到可领取的随机红包");
			mSleep(1000);
			log_and_restart('没有红包可以领取！')
		end
	end
	
end

--获取手机号码
function get_mobile_number(token, sid)	
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?";
	--url = url .. "action=getPhone" .. "&sid=" .. sid .. "&token=" .. token;
	
	local curr_mobileNo = '1';
    local random = math.random(1, 5);
    curr_mobileNo = curr_mobileNo .. string.sub('34578', random, random);    
	for i = 1, 9 do
        local random = math.random(1, 10);
        curr_mobileNo = curr_mobileNo .. string.sub('0123456789', random, random);
    end
	
--	for num = 1, 10 do
--		local res, code = http.request(url);
--		code = 200;
--		if (code == 200) then
--			local resultArr = string.split(res, "|");
--	        if(resultArr[1] == "1") then
--		        curr_mobileNo = resultArr[2];
--		        break;			
--	        end
--			curr_mobileNo = '18372649152';
--		end
--		mSleep(3000);
--    end
	return curr_mobileNo;
end










--截取全屏图片  开发时使用
function short_all_screen(imgName,quality)
	local w,h = getScreenSize();
	keepScreen(true);
	snapshot(imgName, 0, 0, w-1, h-1, quality or 90); 
	keepScreen(false);
end 
--截取指定区域的图片  开发时使用
function short_point_area_screen(imgName,x1,y1,x2,y2,quality)
	keepScreen(true);
	snapshot(imgName, x1, y1, x2, y2, quality or 90); 
	keepScreen(false);
end