
function getMobileAndToken()
	local sz = require("sz");
    local http = require("szocket.http");
	--local url = "http://139.199.65.115:1218/?name=weixin_phone&opt=get&auth=Fb@345!";
	local url = "http://api.xingjk.cn/api/do.php?action=loginIn&name=api-9ax7vsgf&password=diandianchuxing";
	
	
	local mobileInfo = {};
	for num = 1, 10 do
		local res, code = http.request(url);
		nLog(res .. '|' .. '111111')
		nLog(code .. '|' .. '222222')
		if (code == 200) then
			local resultArr = string.split(res, "|");
			mobileInfo["mobileNo"] = resultArr[1];
			mobileInfo["token"] = resultArr[2];
			break;
		else
			mSleep(3000);
		end
    end
	return mobileInfo;
end
