bot = dofile('/home/ta13/inline/utils.lua')
json = dofile('/home/ta13/inline/JSON.lua')
URL = require "socket.url"
serpent = require("serpent")
http = require "socket.http"
https = require "ssl.https"
redis = require('redis')
db = redis.connect('127.0.0.1', 6379)
BASE = '/home/ta13/inline/'
SUDO = 384241114 -- sudo id
sudo_users = {384241114,Userid}
BOTS = 249464384 -- bot id
bot_id = db:get(SUDO..'bot_id')
db:set(SUDO..'bot_on',"on")
function vardump(value)
  print(serpent.block(value, {comment=false}))
end
function dl_cb(arg, data)
 -- vardump(data)
  --vardump(arg)
end

  function is_sudo(msg)
  local var = false
  for k,v in pairs(sudo_users) do
    if msg.sender_user_id_ == v then
      var = true
    end
  end
  return var
end
---------------------chek gp-------------------------------#MehTi 
function chackgp(msg) 
local hash = db:sismember('bot:gps', msg.chat_id_)
if hash then
return true
else
return false
end
end
---------------------sudos---------------------------------#MehTi
function is_sudoers(msg) 
local hash = db:sismember(SUDO..'helpsudo:',msg.sender_user_id_)
if hash or is_sudo(msg) then
return true
else
return false
end
end
-----------------------------------------------------------
function is_master(msg) 
  local hash = db:sismember(SUDO..'masters:',msg.sender_user_id_)
if hash or is_sudo(msg) or is_sudoers(msg) then
return true
else
return false
end
end
------------------------------------------------------------
function is_bot(msg)
  if tonumber(BOTS) == 330376543 then
    return true
    else
    return false
    end
  end
  ------------------------------------------------------------
function is_owner(msg) 
 local hash = db:sismember(SUDO..'owners:'..msg.chat_id_,msg.sender_user_id_)
if hash or is_sudo(msg) or is_sudoers(msg) then
return true
else
return false
end
end
------------------------------------------------------------
function is_mod(msg) 
local hash = db:sismember(SUDO..'mods:'..msg.chat_id_,msg.sender_user_id_)
if hash or is_sudo(msg) or is_owner(msg) or is_sudoers(msg) then
return true
else
return false
end
end
------------------------------------------------------------
function is_banned(chat,user)
   local hash =  db:sismember(SUDO..'banned'..chat,user)
  if hash then
    return true
    else
    return false
    end
	end 
----------------------banall-------------------------------
function is_banall(chat,user)
   local hash =  db:sismember(SUDO..'banalled',user)
  if hash then
    return true
    else
    return false
    end
  end
  ------------------------------------------------------------
  function is_filter(msg, value)
  local hash = db:smembers(SUDO..'filters:'..msg.chat_id_)
  if hash then
    local names = db:smembers(SUDO..'filters:'..msg.chat_id_)
    local text = ''
    for i=1, #names do
	   if string.match(value:lower(), names[i]:lower()) and not is_mod(msg) then
	     local id = msg.id_
         local msgs = {[0] = id}
         local chat = msg.chat_id_
        delete_msg(chat,msgs)
       end
    end
  end
  end
  ------------------------------------------------------------
function is_muted(chat,user)
   local hash =  db:sismember(SUDO..'mutes'..chat,user)
  if hash then
    return true
    else
    return false
    end
  end
  	-----------------------------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification) 
   tdcli_function ({ 
     ID = "PinChannelMessage", 
     channel_id_ = getChatId(channel_id).ID, 
     message_id_ = message_id, 
     disable_notification_ = disable_notification 
   }, dl_cb, nil) 
end 
-----------------------------------------------------------------------------------------------
function priv(chat,user)
  local ohash = db:sismember(SUDO..'owners:'..chat,user)
  local mhash = db:sismember(SUDO..'mods:'..chat,user)
  local shash = db:sismember(SUDO..'helpsudo:',user)
  local mahash = db:sismember(SUDO..'master:',user)
 if tonumber(SUDO) == tonumber(user) or mhash or ohash or shash or mahash then
   return true
    else
    return false
    end
  end
  ------------------------------------------------------------
function kick(msg,chat,user)
  if tonumber(user) == tonumber(bot_id) then
    return false
    end
  if priv(chat,user) then
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شما نمیتوانید دیگر مدیران را اخراج کنید!</code>', 'html')
    else
  bot.changeChatMemberStatus(chat, user, "Kicked")
    end
  end
  ------------------------------------------------------------
function ban(msg,chat,user)
  if tonumber(user) == tonumber(bot_id) then
    return false
    end
  if priv(chat,user) then
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شما نمیتوانید دیگر مدیران را از گروه مسدود کنید!</code>', 'html')
    else
  bot.changeChatMemberStatus(chat, user, "Kicked")
  db:sadd(SUDO..'banned'..chat,user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>] <code>از گروه مسدود گردید.</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t, 1, 'html')
  end
  end
---------------------------ban all -------------------------------
function banall(msg,chat,user)
  if tonumber(user) == tonumber(bot_id) then
    return false
    end
  if priv(chat,user) then
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شما نمیتوانید دیگر مدیران را از گروه مسدود کنید!</code>', 'html')
    else
  bot.changeChatMemberStatus(chat, user, "Kicked")
  db:sadd(SUDO..'banalled',user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>] <code>به لیست گلوبال بن ربات اضافه شد و دیگر نمیتواند در گروه هایی که ربات است وارد شود</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t, 1, 'html')
  end
  end
  -----------------------------------------------------------
function mute(msg,chat,user)
    if tonumber(user) == tonumber(bot_id) then
    return false
    end
  if priv(chat,user) then
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شما نمیتوانید توانایی گفتگو در گروه را از دیگر مدیران سلب کنید!</code>', 'html')
    else
  db:sadd(SUDO..'mutes'..chat,user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>] <code>به حالت سکوت کاربران افزوده گردید.</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t,1, 'html')
  end
  end
  ------------------------------------------------------------
function unban(msg,chat,user)
    if tonumber(user) == tonumber(bot_id) then
    return false
    end
   db:srem(SUDO..'banned'..chat,user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>] <code>از لیست کاربران مسدود شده خارج گردید.</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t,1, 'html')
  end
  ------------------------------------------------------------
  function unbanall(msg,chat,user)
    if tonumber(user) == tonumber(bot_id) then
    return false
    end
   db:srem(SUDO..'banalled',user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>] <code>از لیست گلوبال بن حذف شد و میتواند در تمامی گروه هایی که ربات در آن ادمین است فعالیت داشته باشد</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t,1, 'html')
  end
  ------------------------------------------------------------
function unmute(msg,chat,user)
    if tonumber(user) == tonumber(bot_id) then
    return false
    end
   db:srem(SUDO..'mutes'..chat,user)
  local t = '<code>>کاربر</code> [<b>'..user..'</b>]  <code>از حالت سکوت کاربران حذف گردید.</code>'
  bot.sendMessage(msg.chat_id_, msg.id_, 1, t,1, 'html')
  end
  ------------------------------------------------------------
 function delete_msg(chatid,mid)
  tdcli_function ({ID="DeleteMessages", chat_id_=chatid, message_ids_=mid}, dl_cb, nil)
end
------------------------------------------------------------
function user(msg,chat,text,user)
  entities = {}
  if text:match('<user>') and text:match('<user>') then
      local x = string.len(text:match('(.*)<user>'))
      local offset = x
      local y = string.len(text:match('<user>(.*)</user>'))
      local length = y
      text = text:gsub('<user>','')
      text = text:gsub('</user>','')
   table.insert(entities,{ID="MessageEntityMentionName", offset_=offset, length_=length, user_id_=user})
  end
    entities[0] = {ID='MessageEntityBold', offset_=0, length_=0}
return tdcli_function ({ID="SendMessage", chat_id_=chat, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_=entities}}, dl_cb, nil)
end
------------------------------------------------------------
function settings(msg,value,lock) 
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
  if value == 'file' then
      text = '📂ارسال فایل'
   elseif value == 'keyboard' then
    text = '⛓ارسال دکمه شیشه ای'
  elseif value == 'link' then
    text = '🌐ارسال لینک'
  elseif value == 'game' then
    text = '🎮ارسال بازی'
    elseif value == 'username' then
    text = '🆔ارسال تگ'
   elseif value == 'pin' then
    text = '🔰سنجاق کردن'
    elseif value == 'photo' then
    text = '🌠ارسال عکس'
    elseif value == 'gif' then
    text = '🖼ارسال گیف'
    elseif value == 'video' then
    text = '🎥ارسال ویدئو'
    elseif value == 'audio' then
    text = '🎤ارسال ویس'
    elseif value == 'music' then
    text = '🎶ارسال آهنگ'
    elseif value == 'text' then
    text = '📝ارسال متن'
    elseif value == 'sticker' then
    text = '🌅ارسال عکس'
    elseif value == 'contact' then
    text = '☎️ارسال مخاطب'
    elseif value == 'forward' then
    text = '🔗ارسال فوروارد'
    elseif value == 'persian' then
    text = '🇮🇷متن فارسی'
    elseif value == 'english' then
    text = '🇳🇿متن انگلیسی'
    elseif value == 'bot' then
    text = '🤖ورود ربات'
    elseif value == 'tgservice' then
    text = '⚙️سرویس های تلگرام'
    else return false
    end
  if lock then
db:set(hash,true)
local id = msg.sender_user_id_
           local lmsg = '✔️پی وی قفل کننده✔️\n➖➖➖➖➖➖➖➖➖\n'..text..' 》 قفل شد🔐\n➖➖➖➖➖➖➖➖➖\n👉 @Nice20Team'
            tdcli_function ({
			ID="SendMessage",
			chat_id_=msg.chat_id_,
			reply_to_message_id_=msg.id_,
			disable_notification_=0,
			from_background_=1,
			reply_markup_=nil,
			input_message_content_={ID="InputMessageText",
			text_=lmsg,
			disable_web_page_preview_=1,
			clear_draft_=0,
			 parse_mode_ = md,
			entities_={[0] = {ID="MessageEntityMentionName",
			offset_=0,
			length_=20,
			user_id_=id
			}}}}, dl_cb, nil)
    else
  db:del(hash)
local id = msg.sender_user_id_
           local Umsg = '✔️پی وی آزاد کننده✔️\n➖➖➖➖➖➖➖➖➖\n'..text..' 》 آزاد شد🔓\n➖➖➖➖➖➖➖➖➖\n👉 @Nice20Team'
            tdcli_function ({
			ID="SendMessage",
			chat_id_=msg.chat_id_,
			reply_to_message_id_=msg.id_,
			disable_notification_=0,
			from_background_=1,
			reply_markup_=nil,
			input_message_content_={ID="InputMessageText",
			text_=Umsg,
			disable_web_page_preview_=1,
			clear_draft_=0,
			entities_={[0] = {ID="MessageEntityMentionName",
			offset_=0,
			length_=36,
			user_id_=id
			}}}}, dl_cb, nil)
end
end
------------------------------------------------------------
function is_lock(msg,value)
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
 if db:get(hash) then
    return true 
    else
    return false
    end
  end
  
-----------------------------fanection warn------------------------------
function warn(msg,chat,user)
local ch = msg.chat_id_
  local type = db:hget("warn:settings:"..ch,"swarn")
  if type == "kick" then
    kick(msg,chat,user)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به دلیل دریافت اخطار بیش ار حد(بیش از حد مجاز) از گروه اخراج گردید و ارتباط آن با گروه قطع گردید.</code>', 1,'html')
    end
  if type == "ban" then
    if is_banned(chat,user) then else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به دلیل دریافت اخطار بیش از حداز گروه مسدود گردید و ارتباط آن با گروه قطع گردید.</code>', 1,'html')
      end
bot.changeChatMemberStatus(chat, user, "Kicked")
  db:sadd(SUDO..'banned'..msg.chat_id_,user)
  end
	if type == "mute" then
    if is_muted(msg.chat_id_,user) then else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '>کاربر ['..user..'] به دلیل دریافت اخطار (بیش از حد مجاز) به حالت سکوت منتقل شد\nبرای خارج شدن از لیست سکوت کاربران به مدیریت مراجعه کنید', 1,'md')
      end
  db:sadd(SUDO..'mutes'..msg.chat_id_,user)
	end
	end
------------------------------------------------------------
function trigger_anti_spam(msg,type)
  if type == "kick" then
    kick(msg,msg.chat_id_,msg.sender_user_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..msg.sender_user_id_..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) از گروه اخراج گردید و ارتباط آن با گروه قطع گردید.</code>', 1,'html')
    end
  if type == "ban" then
    if is_banned(msg.chat_id_,msg.sender_user_id_) then else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..msg.sender_user_id_..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) از گروه مسدود گردید و ارتباط آن با گروه قطع گردید.</code>', 1,'html')
      end
bot.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
  db:sadd(SUDO..'banned'..msg.chat_id_,msg.sender_user_id_)
  end
	if type == "mute" then
    if is_muted(msg.chat_id_,msg.sender_user_id_) then else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '>کاربر ['..msg.sender_user_id_..'] به دلیل ارسال پیام مکرر(بیش از حد مجاز) به حالت سکوت منتقل شد\nبرای خارج شدن از لیست سکوت کاربران به مدیریت مراجعه کنید', 1,'md')
      end
  db:sadd(SUDO..'mutes'..msg.chat_id_,msg.sender_user_id_)
	end
	end
function televardump(msg,value)
  local text = json:encode(value)
  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 'html')
  end
------------------------------------------------------------
function run(msg,data)
   --vardump(data)
  --televardump(msg,data)
    if msg then
            db:incr(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
      if msg.send_state_.ID == "MessageIsSuccessfullySent" then
      return false 
      end
      end	
   
    if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        chat_type = 'super'
        elseif id:match('^(%d+)') then
        chat_type = 'user'
        else
        chat_type = 'group'
        end
      end
    local text = msg.content_.text_
	if text and text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
		text = text
		end
    --------- messages type -------------------
    if msg.content_.ID == "MessageText" then
      msg_type = 'text'
    end

	if msg.content_.ID == "MessageChatAddMembers" then
	print("NEW ADD")
    msg_type = 'MSG:NewUserAdd'
	end
	
    if msg.content_.ID == "MessageChatJoinByLink" then
      msg_type = 'join'
    end
    if msg.content_.ID == "MessagePhoto" then
      msg_type = 'photo'
      end
    -------------------------------------------
    if msg_type == 'text' and text then
      if text:match('^[/!]') then
      text = text:gsub('^[/!]','')
      end
    end
     if text then
      if not db:get(SUDO..'bot_id') then
         function cb(a,b,c)
         db:set(SUDO..'bot_id',b.id_)
         end
      bot.getMe(cb)
      end
    end
 ------------------------------------------------------------
if chat_type == 'super' then
--------------------------gp add -------------------------
if text == 'اضافه' and is_sudoers(msg) then
db:sadd('bot:gps', msg.chat_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>انجام شد</code>\n<code>گروه به لیست گروه های ربات اضافه شد./nبرای فعال شدن گروه لطفا لینک گروه را ثبت نمایید </code>', 1, 'html')
end 
--------------------------rem add -------------------------
if text == 'حذف' and is_sudoers(msg) then
db:srem('bot:gps', msg.chat_id_)
db:del(SUDO..'mods:'..msg.chat_id_)
db:del(SUDO..'owners:'..msg.chat_id_)
db:del(SUDO..'banned'..msg.chat_id_)
db:del('bot:rules'..msg.chat_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>انجام شد</code>\n<code>گروه از لیست گروه های ربات پاک شد .</code>', 1, 'html')
end
--------------------------set link -----------------------
if text and text:match('^تنظیم لینک (.*)') and is_owner(msg) then
local link = text:match('تنظیم لینک (.*)')
db:set(SUDO..'grouplink'..msg.chat_id_, link)
bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لینک جدید با موفقیت ذخیره و تغییر یافت.</code>\n <code>سوپر گروه با موفقیت فعال شد </code>', 1, 'html')
end
----------------------start prozhect ----------------------
if chackgp(msg) then 
local chcklink = db:get(SUDO..'grouplink'..msg.chat_id_) 
if not chcklink and is_owner(msg) then 
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>لطفا لینک گروه را ثبت کنید در غیر اینصورت ربات غیر فعال در گروهتان باقی میماند</code>', 1, 'html')
else 
local ch = msg.chat_id_
local user_id = msg.sender_user_id_
floods = db:hget("flooding:settings:"..ch,"flood") or  'nil'
max_msg = db:hget("flooding:settings:"..ch,"floodmax") or 5
max_time = db:hget("flooding:settings:"..ch,"floodtime") or 5
------------------Flooding----------------------------#Mehti
if db:hget("flooding:settings:"..ch,"flood") then
if not is_mod(msg) then
if msg.content_.ID == "MessageChatAddMembers" then 
return false
else 
	local post_count = tonumber(db:get('floodc:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
	if post_count > tonumber(db:hget("flooding:settings:"..ch,"floodmax") or 5) then
 local ch = msg.chat_id_
         local type = db:hget("flooding:settings:"..ch,"flood")
         trigger_anti_spam(msg,type)
 end
	db:setex('floodc:'..msg.sender_user_id_..':'..msg.chat_id_, tonumber(db:hget("flooding:settings:"..msg.chat_id_,"floodtime") or 3), post_count+1)
end
end
end
local edit_id = data.text_ or 'nil' --bug #behrad
	 local ch = msg.chat_id_
    max_msg = 5
    if db:hget("flooding:settings:"..ch,"floodmax") then
       max_msg = db:hget("flooding:settings:"..ch,"floodmax")
      end
    if db:hget("flooding:settings:"..ch,"floodtime") then
		max_time = db:hget("flooding:settings:"..ch,"floodtime")
      end
-- save pin message id
  if msg.content_.ID == 'MessagePinMessage' then
 if is_lock(msg,'pin') and is_owner(msg) then
 db:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
  elseif not is_lock(msg,'pin') then
 db:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
 end
 end
 -- check filters
    if text and not is_mod(msg) then
     if is_filter(msg,text) then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
      end 
    end
	
-- end charge expire -- 


local exp = tonumber(db:get('bot:charge:'..msg.chat_id_))
                if exp == 0 then
				exp_dat = 'Unlimited'
				else
			local now = tonumber(os.time())
      if not now then 
      now = 0 
      end
      if not exp then
      exp = 0
      end
			exp_dat = (math.floor((tonumber(exp) - tonumber(now)) / 86400) + 1)      
end
if exp_dat == 1 and is_owner(msg) and not is_sudo(msg) and not is_sudoers(msg) then 
local texter = 'از شارژ گروه فقط یک روز باقی مانده است⚠️\nگروه خود را شارژ کنید❗️\n`در غیر این صورت ربات در 24 ساعت آینده لفت خواهد داد🔅`\n💯 nice20 TeaM'
bot.sendMessage(msg.chat_id_,0,1,texter,0,'md')
end

if exp_dat == 0 and is_owner(msg) and not is_sudo(msg) and not is_sudoers(msg) then
db:del('bot:charge:'..msg.chat_id_)
bot.changeChatMemberStatus(msg.chat_id_, 249464384, "Left")
local texter = 'شارژ گروه تمام شد⚠️\n`گروه از لیست مدیریت ربات حذف شد❗️\nبرای شارژ مجدد به مدیر مراجعه کنیدک 🔅`\n💯nice20 TeaM'
bot.sendMessage(msg.chat_id_,0,1,texter,0,'md')
end
 
 ----------------------------------
-- check settings
    
     -- lock tgservice
      if is_lock(msg,'tgservice') then
        if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatDeleteMember" then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
        end
		
 ---------------edit masg----------------#MehTi	
	
    -- lock pin
    if is_owner(msg) then else
      if is_lock(msg,'pin') then
        if msg.content_.ID == 'MessagePinMessage' then
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>قفل پیغام پین شده فعال است</code>\n<code>شما دارای مقام نمیباشید و امکان پین کردن پیامی را ندارید</code>',1, 'html')
      bot.unpinChannelMessage(msg.chat_id_)
          local PinnedMessage = db:get(SUDO..'pinned'..msg.chat_id_)
          if PinnedMessage then
             bot.pinChannelMessage(msg.chat_id_, tonumber(PinnedMessage), 0)
            end
          end
        end
      end
      if is_mod(msg) then
        else
        -- lock link
        if is_lock(msg,'link') then
          if text then
        if msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID == 'MessageEntityUrl' or msg.content_.text_.web_page_ then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
        end
            end
          if msg.content_.caption_ then
            local text = msg.content_.caption_
       local is_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text:match("[Tt].[Mm][Ee]/")
            if is_link then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
              end
            end
        end
        -- lock username
        if is_lock(msg,'username') then
          if text then
       local is_username = text:match("@[%a%d]")
        if is_username then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
        end
            end
          if msg.content_.caption_ then
            local text = msg.content_.caption_
       local is_username = text:match("@[%a%d]")
            if is_username then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
              end
            end
        end
		
        -- lock sticker 
        if is_lock(msg,'sticker') then
          if msg.content_.ID == 'MessageSticker' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
end
          end
        -- lock forward
        if is_lock(msg,'forward') then
          if msg.forward_info_ then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
          end
        -- lock photo
        if is_lock(msg,'photo') then
          if msg.content_.ID == 'MessagePhoto' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
        end 
        -- lock file
        if is_lock(msg,'file') then
          if msg.content_.ID == 'MessageDocument' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
        end
      -- lock file
        if is_lock(msg,'keyboard') then
          if msg.reply_markup_ and msg.reply_markup_.ID == 'ReplyMarkupInlineKeyboard' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
        end 
      -- lock game
        if is_lock(msg,'game') then
          if msg.content_.game_ then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
          end
        end 
        -- lock music 
        if is_lock(msg,'music') then
          if msg.content_.ID == 'MessageAudio' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end
          end
        -- lock voice 
        if is_lock(msg,'audio') then
          if msg.content_.ID == 'MessageVoice' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end
          end
        -- lock gif
        if is_lock(msg,'gif') then
          if msg.content_.ID == 'MessageAnimation' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end
          end 
        -- lock contact
        if is_lock(msg,'contact') then
          if msg.content_.ID == 'MessageContact' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end
          end
        -- lock video 
        if is_lock(msg,'video') then
          if msg.content_.ID == 'MessageVideo' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
           end
          end
        -- lock text 
        if is_lock(msg,'text') then
          if msg.content_.ID == 'MessageText' then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end
          end
        -- lock persian 
        if is_lock(msg,'persian') then
          if text:match('[ضصثقفغعهخحجچپشسیبلاتنمکگظطزرذدئو]') then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end 
         if msg.content_.caption_ then
        local text = msg.content_.caption_
       local is_persian = text:match("[ضصثقفغعهخحجچپشسیبلاتنمکگظطزرذدئو]")
            if is_persian then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
              end
            end
        end
        -- lock english 
        if is_lock(msg,'english') then
          if text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
            end 
         if msg.content_.caption_ then
        local text = msg.content_.caption_
       local is_english = text:match("[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]")
            if is_english then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
              end
            end
        end
        -- lock bot
        if is_lock(msg,'bot') then
       if msg.content_.ID == "MessageChatAddMembers" then
            if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
        kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
              end
            end
          end
      end

-- check mutes
      local muteall = db:get(SUDO..'muteall'..msg.chat_id_)
      if msg.sender_user_id_ and muteall and not is_mod(msg) then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
      end
      if msg.sender_user_id_ and is_muted(msg.chat_id_,msg.sender_user_id_) then
      delete_msg(msg.chat_id_, {[0] = msg.id_})
      end
-- check bans
    if msg.sender_user_id_ and is_banned(msg.chat_id_,msg.sender_user_id_) then
      kick(msg,msg.chat_id_,msg.sender_user_id_)
      end
    if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_banned(msg.chat_id_,msg.content_.members_[0].id_) then
      kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>کاربر مورد نظر مسدود نمیباشد!</code>',1, 'html')
      end
-- check banalls	  
    if msg.sender_user_id_ and is_banall(msg.chat_id_,msg.sender_user_id_) then
      kick(msg,msg.chat_id_,msg.sender_user_id_)
      end
    if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_banall(msg.chat_id_,msg.content_.members_[0].id_) then
      kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
      bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>کاربرا مورد نظر گلوبال بن میباشد</code>',1, 'html')
      end	    
-- welcome
    local status_welcome = (db:get(SUDO..'status:welcome:'..msg.chat_id_) or 'disable') 
    if status_welcome == 'enable' then
			    if msg.content_.ID == "MessageChatJoinByLink" then
        if not is_banned(msg.chat_id_,msg.sender_user_id_) and not is_banall(msg.chat_id_,msg.sender_user_id_) then
     function wlc(extra,result,success)
        if db:get(SUDO..'welcome:'..msg.chat_id_) then
        t = db:get(SUDO..'welcome:'..msg.chat_id_)
        else
        t = 'سلام {name}\nخوش آمدید!'
        end
      local t = t:gsub('{name}',result.first_name_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
          end
        bot.getUser(msg.sender_user_id_,wlc)
      end
        end
        if msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].type_.ID == 'UserTypeGeneral' then

    if msg.content_.ID == "MessageChatAddMembers" then
      if not is_banned(msg.chat_id_,msg.content_.members_[0].id_) and not is_banall(msg.chat_id_,msg.content_.members_[0].id_) then
      if db:get(SUDO..'welcome:'..msg.chat_id_) then
        t = db:get(SUDO..'welcome:'..msg.chat_id_)
        else
        t = 'سلام {name}\nخوش آمدید!'
        end
      local t = t:gsub('{name}',msg.content_.members_[0].first_name_)
         bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
      end
        end
          end
      end
      -- locks
    if text and is_owner(msg) then
      local lock = text:match('^قفل سنجاق$')
       local unlock = text:match('^بازکردن سنجاق$')
      if lock then
          settings(msg,'pin','lock')
          end
        if unlock then
          settings(msg,'pin')
        end
      end 
    if text and is_mod(msg) then
---------------lock by #MehTi---------------
	if text:match('^قفل (.*)$') then
       local lock = text:match('^قفل (.*)$')   
	   local locks = {"همه","فلود","اسپم","لینک","فراخوانی","تگ","یوزرنیم","انگلیسی","عربی","فوروارد","ریپلی","شکلک","ادیت","سنجاق","دستور","اد ممبر","جوین ممبر","ربات","عکس","ویدیو","گیف","استیکر","فایل","اینلاین","متن","ویس","مان","مخاطب"}
local suc = 0
for i,v in pairs(locks) do
if lock == v:lower() then
suc = 1
settings(msg,lock,'lock')
end 
end 
if suc == 0 then
local text = "*❗️خطا*\n_⚠️ قفل پیدا نشد\n_*🔅Locks List:*\n"
for i,v in pairs(locks) do
text = text..'_'..i..' - '..v..'_\n'
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,text, 1, 'md')
end
end


------------------------------------------------
if text:match('^ادیت (lock)$') then
local locking = text:match('^ادیت (lock)$') 
db:set('edit:Lock:'..msg.chat_id_,'lock')
textedit = "ok"
bot.sendMessage(msg.chat_id_, msg.id_, 1,textedit, 1, 'md')
end
 ----------------Lock By #MehTi-----------------
if text:match('^بازکردن (.*)$') then
local unlock = text:match('^بازکردن (.*)$')   
local locks = {"همه","فلود","اسپم","لینک","فواخوانی","تگ","یوزرنیم","انگلیسی","عربی","فوروارد","ریپلی","شکلک","ادیت","سنجاق","دستور","اد ممبر","جوین ممبر","ربات","عکس","ویدیو","گیف","استیکر","فایل","اینلاین","متن","ویس","مکان","مخاطب"}
local suc = 0
for i,v in pairs(locks) do
if unlock == v:lower() then
suc = 1
settings(msg,unlock)
end 
end 
if suc == 0 then
local text = "*❗️خطا*\n_⚠️ قفل پیدا نشد\n_*🔅Locks List:*\n"
for i,v in pairs(locks) do
text = text..'_'..i..' - '..v..'_\n'
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,text, 1, 'md')
end
end
-------------------end lock ---------------------------#MehTi 
 
       local unlock = text:match('^بازکردن (.*)$')
      local pin = text:match('^قفل سنجاق$') or text:match('^بازکردن سنجاق$')
      if pin and is_owner(msg) then
        elseif pin and not is_owner(msg) then
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>انجام این دستور برای شما مجاز نمیباشد!</code>',1, 'html') 
        end
        end
    
 -- lock flood settings
    if text and is_owner(msg) then
	   local ch = msg.chat_id_
      if text == 'فلود اخراج' then
      db:hset("flooding:settings:"..ch ,"flood",'kick') 
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>اخراج(کاربر)</i>',1, 'html')
      elseif text == 'فلود بن' then
        db:hset("flooding:settings:"..ch ,"flood",'ban') 
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>مسدود-سازی(کاربر)</i>',1, 'html')
        elseif text == 'فلود سایلنت' then
        db:hset("flooding:settings:"..ch ,"flood",'mute') 
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>سکوت(کاربر)</i>',1, 'html')
        elseif text == 'بازکردن فلود' then
        db:hdel("flooding:settings:"..ch ,"flood") 
        bot.sendMessage(msg.chat_id_, msg.id_, 1, ' <code>قفل ارسال پیام مکرر غیرفعال گردید!</code> ',1, 'html')
            end
          end
       
        -- sudo
    if text then
	
  -------------------info------------------------#MehTi
if text and text:match('^اطلاعات') then 
	local ch = msg.chat_id_
	local user = msg.sender_user_id_
    local name = db:hget("mehti:info:"..user, "name")
	if not name then 
    name = '----'
	end 
	local lastname = db:hget('mehti:info'..user, 'lname') 
	if not lastname then 
	lastname = '----'
	end 
	local sex = db:hget('mehti:info'..user, 'sex')
	local bio = db:hget('mehti:info'..user, 'bio')
	local hiphop = db:hget("mehti:info"..user, "hiphop")
	local cstm = db:hget('mehti:info'..user, 'cstm')
	local usermsg = db:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
	local url , res = http.request('http://irapi.ir/time')
    if res ~= 200 then
	return "No connection"
    end
	local jdat = json:decode(url)
	
	 if is_sudo(msg) then
	  t = 'FullSudo'
      elseif is_sudoers(msg) then
	  t = 'HelpSudo'
      elseif is_owner(msg) then
	  t = 'Group Owner'
      elseif is_mod(msg) then
	  t = 'Moderator'
      else
	  t = 'Member'
	  end
	
	
	if cstm and sex and hiphop and bio then 
	  local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها  : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖اطلاعات بیشتر➖➖\n🔅جنسیت : '..sex..'\n🔅ماه تولد : '..bio..'\n🔅سن : '..hiphop..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and sex and hiphop and not bio then 
	  	  local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما: '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖اطلاعات بیشتر➖➖\n🔅جنسیت : '..sex..'\n🔅سن : '..hiphop..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and hiphop and bio and not sex then 
	  	  local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖ اطلاعات بیشتر➖➖\n🔅ماه تولد : '..bio..'\n🔅سن : '..hiphop..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and sex and bio and not hiphop then 
	  	  local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖ اطلاعات بیشتر ➖➖\n🔅جنسیت : '..sex..'\n🔅ماه تولد : '..bio..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and sex and not hiphop and not bio then 
	  	  local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖اطلاعات بیشتر➖➖\n🔅جنسیت : '..sex..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and not sex and hiphop and not bio then
	      local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖اطلاعات بیشتر➖➖\n🔅سن : '..hiphop..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	  elseif cstm and not sex and not hiphop and bio then
	      local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها  : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖اطلاعات بیشتر➖➖\n🔅ماه تولد : '..bio..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
 bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	 else 
	 local text = '🔅نام : '..name..'\n🔅فامیلی : '..lastname..'\n🔅شناسه شما : '..user..'\n🔅شناسه گروه : '..ch..'\n🔅تعداد پیامها  : '..usermsg..'\n🔅رتبه : '..t..'\n➖➖تاریخ و زمان➖➖\n⌚️زمان : '..jdat.FAtime..'\n🗓تاریخ : '..jdat.FAdate..''
     bot.sendMessage(msg.chat_id_, msg.id_, 1, text,0)
	end 
	end 
  -------------------id+pro------------------------#MehTi
  		 if text == 'آیدی' then  
local function getpro(extra, result, success)
local msgs = db:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
 if is_sudo(msg) then
	  t = 'FullSudo'
      elseif is_sudoers(msg) then
	  t = 'HelpSudo'
      elseif is_owner(msg) then
	  t = 'Group Owner'
      elseif is_mod(msg) then
	  t = 'Moderator'
      else
	  t = 'Member'
	  end
ch = '@Nice20Team'
   if result.photos_[0] then
       bot.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'👥 شناسه گروه: '..msg.chat_id_:gsub('-100','')..'\n👤 شناسه شما: '..msg.sender_user_id_..'\n🏅رتبه شما: '..t..'\n➰تعداد پیامها :'..msgs..'\n💯Channel :'..ch)
   else
      bot.sendMessage(msg.chat_id_, msg.id_, 1, "شما عکسی ندارید!!\n\n👥 *شناسه گروه:* `"..msg.chat_id_.."`\n*👤 شناسه شما:* `"..msg.sender_user_id_.."`\n*🗣 تعداد پیامهای شما: *`"..msgs.."`", 1, 'md')
   end
   end
   tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = msg.sender_user_id_,
    offset_ = 0,
    limit_ = 1
  }, getpro, nil)
end
-----------------  set sudoers -------------------- #MehTi
	          if text == 'تنظیم سودو' and is_sudo(msg) then
          function sudo_reply(extra, result, success)
        db:sadd(SUDO..'helpsudo:',result.sender_user_id_)
		db:srem(SUDO..'owners:'..result.chat_id_,result.sender_user_id_)
        local user = result.sender_user_id_
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به لیست سودو های ربات افزوده گردید.</code>', 1, 'html')
        end
        if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
          end
        end
        if text and is_sudo(msg) and text:match('^تنظیم سودو (%d+)') then
          local user = text:match('تنظیم سودو (%d+)')
          db:sadd(SUDO..'helpsudo:',user)
		  db:srem(SUDO..'owners:'..msg.chat_id_,user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به لیست سودو های ربات افزوده گردید.</code>', 1, 'html')
      end
--------------- dem sudoers -----------------------#MehTi 
        if text == 'عزل سودو' and is_sudo(msg) then
        function sudo_reply(extra, result, success)
        db:srem(SUDO..'helpsudo:',result.sender_user_id_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..result.sender_user_id_..'</b>] <code>از لیست سودوهای ربات حذف گردید .</code>', 1, 'html')
        end
        if tonumber(msg.reply_to_message_id_) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)  
          end
        end
        if text and text:match('^عزل سودو (%d+)') and is_sudo(msg) then
          local user = text:match('عزل سودو (%d+)')
         db:srem(SUDO..'helpsudo:',user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>از لیست سودوهای ربات حذف گردید .</code>', 1, 'html')
      end
--------------- text -----------------------------------  
	        if is_sudoers(msg) then
-----------ban all ------------------
        if text == 'بن ال' then
		if msg.reply_to_message_id_ == 0 then
        local user = msg.sender_user_id_
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "*wtf? reply kn gole man:)*", 1, 'md')
        else
        function banreply(extra, result, success)
        banall(msg,msg.chat_id_,result.sender_user_id_)
          end
		  end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
        end
		      if text and text:match('بن ال (%d+)') then
        banall(msg,msg.chat_id_,text:match('^بن ال (%d+)'))
        end
      if text and text:match('بن ال @(.*)') then
        local username = text:match('بن ال @(.*)')
        function banusername(extra,result,success)
          if result.id_ then
            banall(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,banusername)
        end
----------------------unbanall-----------------------------
        if text == 'آن بن ال' then
		if msg.reply_to_message_id_ == 0 then
        local user = msg.sender_user_id_
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "*wtf? reply kn gole man:)*", 1, 'md')
		else
        function unbanreply(extra, result, success)
        unbanall(msg,msg.chat_id_,result.sender_user_id_)
          end
		  end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
        end	
      if text and text:match('آن بن ال (%d+)') then
        unbanall(msg,msg.chat_id_,text:match('آن بن ال (%d+)'))
        end
      if text and text:match('^آن بن ال @(.*)') then
        local username = text:match('آن بن ال @(.*)')
        function unbanusername(extra,result,success)
          if result.id_ then
            unbanall(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,unbanusername)
        end
----------------------------------------------------------		
        if text == 'ترک' then
            bot.changeChatMemberStatus(msg.chat_id_, 249464384, "Left")
          end
        if text == 'تنطیم مالک' then
          function prom_reply(extra, result, success)
        db:sadd(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
		db:srem(SUDO..'helpsudo:',result.sender_user_id_)
        local user = result.sender_user_id_
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به لیست مالکین گروه افزوده گردید.</code>', 1, 'html')
        end
        if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
          end
        end
        if text and text:match('^تنظیم مالک (%d+)') then
          local user = text:match('تنظیم مالک (%d+)')
          db:sadd(SUDO..'owners:'..msg.chat_id_,user)
		  db:srem(SUDO..'helpsudo:',user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به لیست مالکین گروه افزوده گردید.</code>', 1, 'html')
      end
        if text == 'عزل مالک' then
        function prom_reply(extra, result, success)
        db:srem(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..result.sender_user_id_..'</b>] <code>از لیست مالکین گروه حذف گردید و توانایی مدیریت گروه از کاربر گفته شد.</code>', 1, 'html')
        end
        if tonumber(msg.reply_to_message_id_) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)  
          end
        end
        if text and text:match('^عزل مالک (%d+)') then
          local user = text:match('عزل مالک (%d+)')
         db:srem(SUDO..'owners:'..msg.chat_id_,user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>از لیست مالکین گروه حذف گردید و توانایی مدیریت گروه از کاربر گفته شد.</code>', 1, 'html')
      end
        end
      if text == 'عزل مالکان' or text == 'عزل همه مالکان' then
        db:del(SUDO..'owners:'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>به لیست ادمین های ربات افزوده گردید.</code>', 1, 'html')
        end
      --------------------------master--------------------------
	   if text == 'تنظیم ادمین' then
          function prom_reply(extra, result, success)
        db:sadd(SUDO..'masters:'..result.sender_user_id_)
        local master = result.sender_user_id_
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..master..'</b>] <code>به لیست ادمین های ربات افزوده گردید.</code>', 1, 'html')
        end
        if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
          end
        end
        if text and text:match('^تنظیم ادمین (%d+)') then
          local master = text:match('تنظیم ادمین (%d+)')
          db:sadd(SUDO..'masters:'..master)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..master..'</b>] <code>به لیست ادمین های ربات افزوده گردید.</code>', 1, 'html')
      end
        if text == 'عزل ادمین' then
        function prom_reply(extra, result, success)
        db:srem(SUDO..'masters:'..result.sender_user_id_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..result.sender_user_id_..'</b>] <code>از لیست ادمین های ربات حذف گردید.</code>', 1, 'html')
        end
        if tonumber(msg.reply_to_message_id_) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)  
          end
        if text and text:match('^عزل ادمین (%d+)') then
          local master = text:match('عزل ادمین (%d+)')
         db:srem(SUDO..'masters:'..master)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..master..'</b>] <code>از لیست ادمین های ربات حذف گردید.</code>', 1, 'html')
      end	 
        end

---------------------reload -------------------------
	   if text == 'بارگذاری' and is_sudo(msg) then
       dofile('./cli.lua') 
 bot.sendMessage(msg.chat_id_, msg.id_, 1,'》 <code>ربات Cli</code> <bریلود شد  ✅</b>', 1, 'html')
            end

	   if text == 'بارگذاری اینلاین' and is_sudo(msg) then
       dofile('./api.lua') 
 bot.sendMessage(msg.chat_id_, msg.id_, 1,'》 <code>اینلاین ربات</code> <b>ریلود شد  ✅</b>', 1, 'html')
            end
	    if text == 'نایس' and is_sudoers(msg) then
    local gps = db:scard("botgp")
	local users = db:scard("usersbot")
    local allmgs = db:get("allmsg")

					bot.sendMessage(msg.chat_id_, msg.id_, 1, '➖➖➖➖➖➖➖➖➖➖\n`⚜️ نایس ربات` *V 2*✅\n\n*🌐کانال تیم 👇*\n\n`https://telegram.me/Nice20Team\n`\n➖➖➖➖➖➖➖➖➖➖\n_📊 وضعیت ربات 👇_\n\n*🌀 گروهها 👉* `'..gps..'`\n*👤 اعضا 👉* `'..users..'`\n*📝کل پیامها 👉* `'..allmgs..'`\n➖➖➖➖➖➖➖➖➖➖', 1, 'md')
	end
	  -----------------owner------------------------
      -- owner
	  
     if is_owner(msg) then
        if text == 'پاک کردن رباتها' then
      local function cb(extra,result,success)
      local bots = result.members_
      for i=0 , #bots do
          kick(msg,msg.chat_id_,bots[i].user_id_)
          end
        end
       bot.channel_get_bots(msg.chat_id_,cb)
       end
          if text == 'حذف لینک' then
            db:del(SUDO..'grouplink'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لینک تنظیم شده با موفقیت بازنشانی گردید.</code>', 1, 'html')
            end
            if text and text:match('^setname (.*)') then
            local name = text:match('^setname (.*)')
            bot.changeChatTitle(msg.chat_id_, name)
            end
        if text == 'خوشامد روشن' then
          db:set(SUDO..'status:welcome:'..msg.chat_id_,'enable')
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>ارسال پیام خوش آمدگویی فعال گردید.</code>', 1, 'html')
          end
        if text == 'خوشامد خاموش' then
          db:set(SUDO..'status:welcome:'..msg.chat_id_,'disable')
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>ارسال پیام خوش آمدگویی غیرفعال گردید.</code>', 1, 'html')
          end
        if text and text:match('^setwelcome (.*)') then
          local welcome = text:match('^setwelcome (.*)')
          db:set(SUDO..'welcome:'..msg.chat_id_,welcome)
          local t = '<code>>پیغام خوش آمدگویی با موفقیت ذخیره و تغییر یافت.</code>\n<code>>متن پیام خوش آمدگویی تنظیم شده:</code>:\n{<code>'..welcome..'</code>}'
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
          end
        if text == 'حذف خوشامد' then
          db:del(SUDO..'welcome:'..msg.chat_id_,welcome)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>پیغام خوش آمدگویی بازنشانی گردید و به حالت پیشفرض تنظیم شد.</code>', 1, 'html')
          end
        if text == 'owners' or text == 'ownerlist' then
          local list = db:smembers(SUDO..'owners:'..msg.chat_id_)
          local t = '<code>>لیست مالکین گروه:</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - <code>"..v.."</code>\n" 
          end
          t = t..'\nبرای مشاهده کاربر از دستور زیر استفاده کنید \n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 234458457</code>'
          if #list == 0 then
          t = '<code>>لیست مالکان گروه خالی میباشد!</code>'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end
    if text == 'تنظیم مدیر' then
        function prom_reply(extra, result, success)
        db:sadd(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
        local user = result.sender_user_id_
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به مقام مدیریت گروه ارتقاء یافت.</code>', 1, 'html')
        end
        if tonumber(msg.reply_to_message_id_) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)  
          end
        end
        if text:match('^تنظیم مدیر @(.*)') then
        local username = text:match('^تنظیم مدیر @(.*)')
        function promreply(extra,result,success)
          if result.id_ then
        db:sadd(SUDO..'mods:'..msg.chat_id_,result.id_)
        text ='<code>>کاربر</code> [<code>'..result.id_..'</code>] <code>به مقام مدیریت گروه ارتقاء یافت.</code>' 
            else 
            text = '<code>کاربر مورد نظر یافت نشد</code>'
            end
           bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
          end
        bot.resolve_username(username,promreply)
        end
        if text and text:match('^تنظیم مدیر (%d+)') then
          local user = text:match('تنظیم مدیر (%d+)')
          db:sadd(SUDO..'mods:'..msg.chat_id_,user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به مقام مدیریت گروه ارتقاء یافت.</code>', 1, 'html')
      end
        if text == 'عزل مدیر' then
        function prom_reply(extra, result, success)
        db:srem(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..result.sender_user_id_..'</b>] <code>از مقام مدیریت گروه عزل گردید.</code>', 1, 'html')
        end
        if tonumber(msg.reply_to_message_id_) == 0 then
        else
           bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)  
          end
        end
        if text:match('^عزل مدیر @(.*)') then
        local username = text:match('عزل مدیر @(.*)')
        function demreply(extra,result,success)
          if result.id_ then
        db:srem(SUDO..'mods:'..msg.chat_id_,result.id_)
        text = '<code>>کاربر</code> [<b>'..result.id_..'</b>] <code>از مقام مدیریت گروه عزل گردید.</code>'
            else 
            text = '<code>کاربر مورد نظر یافت نشد</code>'
            end
           bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
          end
        bot.resolve_username(username,demreply)
        end
        if text and text:match('^تنظیم مدیر (%d+)') then
          local user = text:match('تنظیم مدیر (%d+)')
          db:sadd(SUDO..'mods:'..msg.chat_id_,user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>به مقام مدیریت گروه ارتقاء یافت.</code>', 1, 'html')
      end
        if text and text:match('عزل مدیر (%d+)') then
          local user = text:match('عزل مدیر (%d+)')
         db:srem(SUDO..'mods:'..msg.chat_id_,user)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>کاربر</code> [<b>'..user..'</b>] <code>از مقام مدیریت گروه عزل گردید.</code>', 1, 'html')
      end
  end
      end
	  
---on bot --------

             if db:get(SUDO..'bot_on') == "on" then
			 		local url , res = http.request('http://irapi.ir/time')
		if res ~= 200 then
			return "No connection"
end
	local jdat = json:decode(url)
			 local idgp = 382004593
			 local text = '🔴*The robot went online*\n➖➖➖➖➖➖➖➖\n🔹*زمان:* `'..jdat.ENtime..'`\n➖➖➖➖➖➖➖➖\n🔸*تاریخ:* `'..jdat.FAdate..'`\n➖➖➖➖➖➖➖➖\n'
			 bot.sendMessage(idgp, 0, 1,text, 1, 'md')
			 db:del(SUDO..'bot_on')
			end
	  
-- mods
    if is_owner(msg) or is_sudoers(msg) or is_mod(msg) then
      local function getsettings(value)
        if value == 'muteall' then
        local hash = db:get(SUDO..'muteall'..msg.chat_id_)
        if hash then
         return '<code>فعال</code>'
          else
          return '<code>غیرفعال</code>'
          end
        elseif value == 'welcome' then
        local hash = db:get(SUDO..'welcome:'..msg.chat_id_)
        if hash == 'enable' then
         return '<code>فعال</code>'
          else
          return '<code>غیرفعال</code>'
          end
        elseif value == 'spam' then
		local ch = msg.chat_id_
        local hash = db:hget("flooding:settings:"..ch,"flood")
        if hash then
             if db:hget("flooding:settings:"..ch, "flood") == "kick" then
         return '<code>User-kick</code>'
              elseif db:hget("flooding:settings:"..ch,"flood") == "ban" then
              return '<code>User-ban</code>'
							elseif db:hget("flooding:settings:"..ch,"flood") == "mute" then
              return '<code>Mute</code>'
              end
          else
          return '<code>مجاز</code>'
          end
        elseif is_lock(msg,value) then
          return '<code>غیرمجاز</code>'
          else
          return '<code>مجاز</code>'
          end
        end
        ---------------------------------------------------
      if text == 'پنل' then
          function inline(arg,data)
          tdcli_function({
        ID = "SendInlineQueryResultMessage",
        chat_id_ = msg.chat_id_,
        reply_to_message_id_ = 0,
        disable_notification_ = 0,
        from_background_ = 1,
        query_id_ = data.inline_query_id_,
        result_id_ = data.results_[0].id_
      }, dl_cb, nil)
            end
          tdcli_function({
      ID = "GetInlineQueryResults",
      bot_user_id_ = 432026535,
      chat_id_ = msg.chat_id_,
      user_location_ = {
        ID = "Location",
        latitude_ = 0,
        longitude_ = 0
      },
      query_ = tostring(msg.chat_id_),
      offset_ = 0
    }, inline, nil)
       end
	   --[[if text == 'muteslist' then
        local text = '><b>Group-Filterlist:</b>\n<b>----------------</b>\n'
        ..'><code>Filter-Photo:</code> |'..getsettings('photo')..'|\n'
        ..'><code>Filter-Video:</code> |'..getsettings('video')..'|\n'
        ..'><code>Filter-Audio:</code> |'..getsettings('voice')..'|\n'
        ..'><code>Filter-Gifs:</code> |'..getsettings('gif')..'|\n'
        ..'><code>Filter-Music:</code> |'..getsettings('music')..'|\n'
        ..'><code>Filter-File:</code> |'..getsettings('file')..'|\n'
        ..'><code>Filter-Text:</code> |'..getsettings('text')..'|\n'
        ..'><code>Filter-Contacts:</code> |'..getsettings('contact')..'|\n'
        ..'><code>Filter-Forward:</code> |'..getsettings('forward')..'|\n'
        ..'><code>Filter(Inline-mod):</code> |'..getsettings('game')..'|\n'
        ..'><code>Filter-Service(Join):</code> |'..getsettings('tgservice')..'|\n'
        ..'><code>Mute-Chat:</code> |'..getsettings('muteall')..'|\n'
        bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, '')
       end]]
      if text and text:match('^تعداد فلود (%d+)$') then
		local ch = msg.chat_id_
          db:hset("flooding:settings:"..ch ,"floodmax" ,text:match('floodmax (.*)'))
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>حداکثر پیام تشخیص ارسال پیام مکرر تنظیم شد به:</code> [<b>'..text:match('floodmax (.*)')..'</b>] <code>تغییر یافت.</code>', 1, 'html')
        end
        if text and text:match('^زمان فلود (%d+)$') then
		local ch = msg.chat_id_
          db:hset("flooding:settings:"..ch ,"floodtime" ,text:match('floodtime (.*)'))
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>حداکثر زمان تشخیص ارسال پیام مکرر تنظیم شد به:</code> [<b>'..text:match('floodtime (.*)')..'</b>] <code>ثانیه.</code>', 1, 'html')
        end
        if text == 'لینک' then
          local link = db:get(SUDO..'grouplink'..msg.chat_id_) 
          if link then
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '➖➖➖➖➖➖➖➖➖\n<b>🌐Group Link👇</b>\n\n👉 '..link..'\n➖➖➖➖➖➖➖➖➖\n⚜️ @Nice20Team', 1, 'html')
            else
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>لینک ورود به گروه تنظیم نشده است.</code>\n<code>ثبت لینک جدید با دستور</code>\n<b>/setlink</b> <i>link</i>\n<code>امکان پذیر است.</code>', 1, 'html')
            end
          end
        if text == 'قفل گروه' then
          db:set(SUDO..'muteall'..msg.chat_id_,true)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '⚜️<code>Mute Chat</code> <b>Has Been Enabled🔇</b>', 1, 'html')
          end
        if text and text:match('قفل گروه(%d+)[mhs]') or text and text:match('^mutechat (%d+) [mhs]') then
          local matches = text:match('^قفل گروه (.*)')
          if matches:match('(%d+)h') then
          time_match = matches:match('(%d+)h')
          time = time_match * 3600
          end
          if matches:match('(%d+)s') then
          time_match = matches:match('(%d+)s')
          time = time_match
          end
          if matches:match('(%d+)m') then
          time_match = matches:match('(%d+)m')
          time = time_match * 60
          end
          local hash = SUDO..'muteall'..msg.chat_id_
          db:setex(hash, tonumber(time), true)
          bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>>فیلتر تمامی گفتگو ها برای مدت زمان</code> [<b>'..time..'</b>] <code>ثانیه فعال گردید.</code>', 1, 'html')
          end
        if text == 'بازکردن گروه' then
          db:del(SUDO..'muteall'..msg.chat_id_)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '⚜️<code>Mute Chat</code> <b>Has Been Disabled🔈</b>', 1, 'html')
          end
        if text == 'وضعیت قفل گروه' then
          local status = db:ttl(SUDO..'muteall'..msg.chat_id_)
          if tonumber(status) < 0 then
            t = 'زمانی برای آزاد شدن چت تعییین نشده است !'
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
            else
          t = '[<b>'..status..'</b>] <code>ثانیه دیگر تا غیرفعال شدن فیلتر تمامی گفتگو ها باقی مانده است.</code>'
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
          end
          end
    if text == 'بن ها' or text == 'لیست بن' then
          local list = db:smembers(SUDO..'banned'..msg.chat_id_)
          local t = '<code>>لیست افراد مسدود شده از گروه:</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - <code>"..v.."</code>\n" 
          end
          t = t..'\n<code>>برای مشاهده کاربر از دستور زیر استفاده کنید </code>\n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 159887854</code>'
          if #list == 0 then
          t = '<code>>لیست افراد مسدود شده از گروه خالی میباشد.</code>'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end
      if text == 'آزادی بن ها' or text == 'آزادی لیست بن' then
        db:del(SUDO..'banned'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لیست کاربران مسدود شده از گروه با موفقیت بازنشانی گردید.</code>', 1, 'html')
        end
		
-------------------------------------
		
   if text == 'لیست بن ال' or text == 'بن ال ها' then
          local list = db:smembers(SUDO..'banalled')
          local t = '<code>>لیست افراد مسدود شده از گروه:</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - <code>"..v.."</code>\n" 
          end
          t = t..'\n<code>>برای مشاهده کاربر از دستور زیر استفاده کنید </code>\n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 159887854</code>'
          if #list == 0 then
          t = '<code>>لیست افراد مسدود شده از گروه خالی میباشد.</code>'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end
      if text == 'حذف لیست بن ال' or text == 'آزادی بن ال ها' then
        db:del(SUDO..'banalled')
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لیست کاربران مسدود شده از گروه با موفقیت بازنشانی گردید.</code>', 1, 'html')
        end	
		
-------------------------------------
		
		
        if text == 'سایلنت ها' or text == 'لیست سایلنت' then
          local list = db:smembers(SUDO..'mutes'..msg.chat_id_)
          local t = '<code>لیست کاربران حالت سکوت</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - <code>"..v.."</code>\n" 
          end
          t = t..'\n<code>>برای مشاهده کاربر از دستور زیر استفاده کنید </code> \n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 159887854</code>'
          if #list == 0 then
          t = 'لیست افراد میوت شده خالی است !'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end      
      if text == 'آزادی سایلنت ها' or text == 'آزادی لیست سایلنت' then
        db:del(SUDO..'mutes'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لیست افراد کاربران لیست سکوت با موفقیت حذف گردید..</code>', 1, 'html')
        end
      if text == 'اخراج' and tonumber(msg.reply_to_message_id_) > 0 then
        function kick_by_reply(extra, result, success)
        kick(msg,msg.chat_id_,result.sender_user_id_)
			text1 = '<code>کاربر مورد نظر اخراج شد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text1, 1, 'html')
          end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kick_by_reply)
        end
		
      if text and text:match('^اخراج (%d+)') then
        kick(msg,msg.chat_id_,text:match('اخراج (%d+)'))
		            text1 = '<code>کاربر مورد نظر اخراج شد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text1, 1, 'html')
        end
      if text and text:match('^اخراج @(.*)') then
        local username = text:match('^اخراج @(.*)')
        function kick_username(extra,result,success)
          if result.id_ then
            kick(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,kick_username)
				  		            text2 = '<code>کاربر مورد نظر اخراج شد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text2, 1, 'html')
        end
		
        if text == 'بن' and tonumber(msg.reply_to_message_id_) > 0 then
        function banreply(extra, result, success)
        ban(msg,msg.chat_id_,result.sender_user_id_)
          end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
        end
      if text and text:match('^بن (%d+)') then
        ban(msg,msg.chat_id_,text:match('^بن (%d+)'))
				            text1 = '<code>کاربر مورد نظر بن شد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text1, 1, 'html')
        end
      if text and text:match('^بن @(.*)') then
        local username = text:match('بن @(.*)')
        function banusername(extra,result,success)
          if result.id_ then
            ban(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,banusername)
				            text1 = '<code>کاربر مورد نظر بن شد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text1, 1, 'html')
        end
      if text == 'آزاد' and tonumber(msg.reply_to_message_id_) > 0 then
        function unbanreply(extra, result, success)
        unban(msg,msg.chat_id_,result.sender_user_id_)
          end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
        end
      if text and text:match('^آزاد (%d+)') then
        unban(msg,msg.chat_id_,text:match('آزاد (%d+)'))
        end
      if text and text:match('^آزاد @(.*)') then
        local username = text:match('آزاد @(.*)')
        function unbanusername(extra,result,success)
          if result.id_ then
            unban(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,unbanusername)
        end
        if text == 'سایلنت' and tonumber(msg.reply_to_message_id_) > 0 then
        function mutereply(extra, result, success)
        mute(msg,msg.chat_id_,result.sender_user_id_)
          end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),mutereply)
        end
      if text and text:match('^سایلنت (%d+)') then
        mute(msg,msg.chat_id_,text:match('سایلنت (%d+)'))
        end
      if text and text:match('^سایلنت @(.*)') then
        local username = text:match('سایلنت @(.*)')
        function muteusername(extra,result,success)
          if result.id_ then
            mute(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,muteusername)
        end
      if text == 'آزاد سایلنت' and tonumber(msg.reply_to_message_id_) > 0 then
        function unmutereply(extra, result, success)
        unmute(msg,msg.chat_id_,result.sender_user_id_)
          end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unmutereply)
        end
      if text and text:match('^آزاد سایلنت(%d+)') then
        unmute(msg,msg.chat_id_,text:match('آزاد سایلنت (%d+)'))
        end
      if text and text:match('^آزاد سایلنت @(.*)') then
        local username = text:match('آزاد سایلنت @(.*)')
        function unmuteusername(extra,result,success)
          if result.id_ then
            unmute(msg,msg.chat_id_,result.id_)
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,unmuteusername)
        end
         if text == 'دعوت' and tonumber(msg.reply_to_message_id_) > 0 then
        function inv_by_reply(extra, result, success)
        bot.addChatMembers(msg.chat_id_,{[0] = result.sender_user_id_})
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),inv_by_reply)
        end
      if text and text:match('^دعوت (%d+)') then
        bot.addChatMembers(msg.chat_id_,{[0] = text:match('دعوت (%d+)')})
        end
      if text and text:match('^دعوت @(.*)') then
        local username = text:match('دعوت @(.*)')
        function invite_username(extra,result,success)
          if result.id_ then
        bot.addChatMembers(msg.chat_id_,{[0] = result.id_})
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
          end
        bot.resolve_username(username,invite_username)
        end  
		
    ----------warn settings --------------
	
	if text and text:match('^تعداد اخطار (%d+)$') then
		local ch = msg.chat_id_
        db:hset("warn:settings:"..ch ,"warnmax" ,text:match('warnmax (%d+)'))
        bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>حداکثر اخطار به تعداد:</code> [<b>'..text:match('warnmax (.*)')..'</b>] <code>تغییر یافت.</code>', 1, 'html')
end
-- lock flood settings
if text and is_owner(msg) then
local ch = msg.chat_id_
if text == 'فلود اخراج' then
db:hset("warn:settings:"..ch ,"swarn",'kick') 
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>وضعیت اخطار در گروه تغییر کرد</code> \n<code>وضعیت</code> > <i>اخراج(کاربر)</i>',1, 'html')
elseif text == 'فلود بن' then
db:hset("warn:settings:"..ch ,"swarn",'ban') 
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>وضعیت اخطار در گروه تغییر کرد</code> \n<code>وضعیت</code> > <i>مسدود-سازی(کاربر)</i>',1, 'html')
elseif text == 'فلود سایلنت' then
db:hset("warn:settings:"..ch ,"swarn",'mute') 
bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>وضعیت اخطار در گروه تغییر کرد</code> \n<code>وضعیت</code> > <i>سکوت(کاربر)</i>',1, 'html')
elseif text == 'فلود پیشفرض' then
db:hset("warn:settings:"..ch ,"swarn",'kick') 
bot.sendMessage(msg.chat_id_, msg.id_, 1, ' <code>وضعیت اخطار در گروه به حالت پیشفرض تغییر کرد </code> ',1, 'html')
end
end

---------------------------------------------------------------------

      if text == 'اخطار' and tonumber(msg.reply_to_message_id_) > 0 then
		function swarn_by_reply(extra, result, success)
		local nwarn = tonumber(db:hget("warn:settings:"..result.chat_id_,result.sender_user_id_) or 0)
	    local wmax = tonumber(db:hget("warn:settings:"..result.chat_id_ ,"warnmax") or 3)
		if nwarn == wmax then
	    db:hset('warn:settings:'..result.chat_id_,result.sender_user_id_,0)
         warn(msg,msg.chat_id_,result.sender_user_id_)
		 else 
		db:hset('warn:settings:'..result.chat_id_,result.sender_user_id_,nwarn + 1)
		bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>انجام شد کاربر['..result.sender_user_id_..']به دلیل عدم رعایت ['..(nwarn + 1)..'/'..wmax..']اخطار دریافت کرد</code>',1, 'html')
		end  
		end 
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),swarn_by_reply)
	end 
	-----------info settings -------------
        --setname 
			  local user = msg.sender_user_id_
      if text and text:match('^تنظیم نام (.*)$') then
	  db:hset("mehti:info:"..user ,"name" ,text:match('تنظیم نام (.*)'))
	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------set lastname -------------
      elseif text and text:match('^تنظیم فامیلی (.*)$') then
	  local lname = text:match('^تنظیم فامیلی (.*)$')
	  db:hset("mehti:info"..user ,"lname" ,lname)
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------set sex -------------
      elseif text and text:match('^تنظیم جنسیت (.*)$') then
	  local sex = text:match('^تنظیم جنسیت (.*)$')
	  db:hset("mehti:info"..user,"sex" ,sex)
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------set bio ------------- 
      elseif text and text:match('^تنظیم ماه تولد (.*)$') then	
	  local bio = text:match('^تنظیم ماه تولد (.*)$')
	  db:hset("mehti:info"..user,"bio" ,bio)
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------set hiphop ----------
	  elseif text and text:match('^تنظیم سن (%d+)$') then	
	  local hp = text:match('^تنظیم سن (%d+)$')
	  db:hset("mehti:info"..user, "hiphop",hp)
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------del name -------------
	  elseif text and text:match('^حذف نام$') then
	  db:hdel("mehti:info:"..user, "name")
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------del lastname -------------
	  elseif text and text:match('^حذف فامیلی$') then
	  db:hdel('mehti:info'..user, 'lname')
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------del sex -------------
	  elseif text and text:match('^حذف جنسیت$') then
	  db:hdel('mehti:info'..user, 'sex')
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------del bio -------------
	  elseif text and text:match('^حذف ماه تولد$') then
	  db:hdel('mehti:info'..user, 'bio')
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------del hh -------------
	  elseif text and text:match('^حذف سن$') then
	  db:hdel('mehti:info'..user, 'hiphop')
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  -----------cstm------------
	  elseif text and text:match('^تنظیم اطلاعات بیشتر$') then
	  text = 12 
	  db:hset("mehti:info"..user,"cstm" ,text)
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  
	  	  elseif text and text:match('^حذف اطلاعات بیشتر$') then
	  db:hdel("mehti:info"..user,"cstm")
	  	  text = "ok"
	  bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
	  end
		
-----------del msg sudo -------------
        
      if  text and text:match('پاک کردن (%d+)$') then
        local limit = tonumber(text:match('^del (%d+)$'))
        if limit > 1000 then
         bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تعداد پیام وارد شده از حد مجاز (1000 پیام) بیشتر است !', 1, 'html')
          else
------------------------------------
         function cb(a,b,c)
        local msgs = b.messages_
        for i=1 , #msgs do
          delete_msg(msg.chat_id_,{[0] = b.messages_[i].id_})
        end
        end
------------------------------------
        bot.getChatHistory(msg.chat_id_, 0, 0, limit + 1,cb)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, limit..' پیام اخیر گروه پاک شد !', 1, 'html')
-------------------------------------
        end
        end
      if tonumber(msg.reply_to_message_id_) > 0 then
    if text == "پاک کردن" then
        delete_msg(msg.chat_id_,{[0] = tonumber(msg.reply_to_message_id_),msg.id_})
    end
        end
	
    if text == 'مدیران' or text == 'لیست مدیران' then
          local list = db:smembers(SUDO..'mods:'..msg.chat_id_)
          local t = '<code>>لیست مدیران گروه:</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - <code>"..v.."</code>\n" 
          end
          t = t..'\n<code>>برای مشاهده کاربر از دستور زیر استفاده کنید </code> \n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 159887854</code>'
          if #list == 0 then
          t = '<code>>مدیریت برای این گروه ثبت نشده است.</code>'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end
      if text == 'عزل مدیران' or text == 'عزل همه مدیران' then
        db:del(SUDO..'mods:'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>لیست مدیران گروه با موفقیت بازنشانی شد</code>', 1, 'html')
        end
      if text and text:match('^فیلتر +(.*)') then
        local w = text:match('^فیلتر +(.*)')
         db:sadd(SUDO..'filters:'..msg.chat_id_,w)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'" '..w..' "  <code>>به لیست کلمات فیلتر شده اضاف گردید!</code>', 1, 'html')
       end
      if text and text:match('^آزاد فیلتر +(.*)') then
        local w = text:match('آزاد فیلتر +(.*)')
         db:srem(SUDO..'filters:'..msg.chat_id_,w)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'" '..w..' "  <code>>از لیست کلمات فیلتر شده پاک شد!</code>', 1, 'html')
       end
      if text == 'آزاد لیست فیلتر' then
        db:del(SUDO..'filters:'..msg.chat_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<code>>تمامی کلمات فیلتر شده با موفقیت حذف گردیدند.</code>', 1, 'html')
        end
      if text == 'ادمین ها' or text == 'لیست ادمین' then
        local function cb(extra,result,success)
        local list = result.members_
           local t = '<code>>لیست ادمین های گروه:</code>\n\n'
          local n = 0
            for k,v in pairs(list) do
           n = (n + 1)
              t = t..n.." - "..v.user_id_.."\n"
                    end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t..'\n<code>>برای مشاهده کاربر از دستور زیر استفاده کنید </code> \n<code>/whois [آیدی کاربر]</code>\n مثال :\n <code>/whois 159887854</code>', 1, 'html')
          end
       bot.channel_get_admins(msg.chat_id_,cb)
      end
      if text == 'لیست فیلتر' then
          local list = db:smembers(SUDO..'filters:'..msg.chat_id_)
          local t = '<code>>لیست کلمات فیلتر شده در گروه:</code> \n\n'
          for k,v in pairs(list) do
          t = t..k.." - "..v.."\n" 
          end
          if #list == 0 then
          t = '<code>>لیست کلمات فیلتر شده خالی میباشد</code>'
          end
          bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'html')
      end
    local msgs = db:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
    if msg_type == 'text' then
        if text then
      if text:match('^چه کسی @(.*)') then
        local username = text:match('^چه کسی @(.*)')
        function id_by_username(extra,result,success)
          if result.id_ then
            text = '<b>⚜️شناسه شما</b> 👉 [<code>'..result.id_..'</code>]\n<b>⚜️تعداد پیامها<b> 👉 <code>'..(db:get(SUDO..'total:messages:'..msg.chat_id_..':'..result.id_) or 0)..'</code>'
            else 
            text = '<code>کاربر مورد نظر یافت نشد!</code>'
            end
           bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
          end
        bot.resolve_username(username,id_by_username)
        end
          if text == 'آیدی گروه' then
            if tonumber(msg.reply_to_message_id_) == 0 then
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شناسه-گروه</code>: {<b>'..msg.chat_id_..'</b>}', 1, 'html')
          end
            end
			
			
	
-------------------Charge Groups -------------#MehTi

        if text and text:match('شارژ (%d+)') and is_sudoers(msg) then
              local chare = text:match('شارژ (%d+)')
if tonumber(chare) < 0 or tonumber(chare) > 999 then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Error*\n_عدداشتباه ,دامنه روزها[1-999]_', 1,'md')
else
		local time = os.time()
		local buytime = tonumber(os.time())
		local timeexpire = tonumber(buytime) + (tonumber(chare) * 86400)
    db:set('bot:charge:'..msg.chat_id_,timeexpire)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*👉انجام شد✅*\n_⚜️شارژ گروه 》 `'..chare..' Dey`', 1,'md')
end 
end 


----------fun------------------

---------------------time ------------------
if text:match('ساعت') then
		local url , res = http.request('http://irapi.ir/time')
		if res ~= 200 then
			return "No connection"
		end
		local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
		local fonts = {'mathbf','mathit','mathfrak','mathrm'}
		local jdat = json:decode(url)
		local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
		local file = download_to_file(url,'time.webp')
		bot.sendDocument(msg.to.id, 0, 0, 1, nil, file, '', dl_cb, nil)
end
--------------------voice-------------------
if text:match('صدا (.+)') then
local matches = text:match('صدا (.+)')
 local text = matches
    textc = text:gsub(' ','.')

  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'MehTi.mp3')
 				bot.sendDocument(msg.chat_id_, 0, 0, 1, nil, file, 'done', dl_cb, nil)
  
end
--------------------tr-----------------------
	if text:match('ترجمه (.+) (.+)') then 
	local matches = text:match('ترجمه (.+) (.+)')
		url = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[2])..'&text='..URL.escape(matches[3]))
		data = json:decode(url)
		local text = 'زبان : '..data.lang..'\nترجمه : '..data.text[1]..''
		bot.sendMessage(msg.chat_id_, 0, 1, text, 1, 'html')
end
------------------weather---------------------
local function get_weather(location)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
	local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد'
	local conditions = 'شرایط فعلی آب و هوا : '
	if weather.weather[1].main == 'Clear' then
		conditions = conditions .. 'آفتابی☀'
	elseif weather.weather[1].main == 'Clouds' then
		conditions = conditions .. 'ابری ☁☁'
	elseif weather.weather[1].main == 'Rain' then
		conditions = conditions .. 'بارانی ☔'
	elseif weather.weather[1].main == 'Thunderstorm' then
		conditions = conditions .. 'طوفانی ☔☔☔☔'
	elseif weather.weather[1].main == 'Mist' then
		conditions = conditions .. 'مه 💨'
	end
	return temp .. '\n' .. conditions
end
	if text:match('آب و هوا (.+)') then 
	local matches = text:match('آب و هوا (.+)')
		city = matches
		local wtext = get_weather(city)
		if not wtext then
			wtext = 'مکان وارد شده صحیح نیست'
		bot.sendMessage(msg.chat_id_, 0, 1, wtext, 1, 'html')
		end
		return wtext
end

---end fun --------------


------------------set rules ----------------------#MehTi
  	if text:match("^تنظیم قوانین (.*)$") and is_mod(msg) then
	local txt = {string.match(text, "^(تنظیم قوانین) (.*)$")}
	db:set('bot:rules'..msg.chat_id_, txt[2])
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '_Group rules upadted..._', 1, 'md')
    end
----------------------get rules-------------------------#MehTi
  	if text:match("^قوانین$") then
	local rules = db:get('bot:rules'..msg.chat_id_)
	bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, rules, 1, 'html')
end
----------------------Pin------------------------------#MehTi
			if text == 'سنجاق' then			
if msg.reply_to_message_id_ == 0 then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Wtf?!*', 1,'md')
else 
bot.pinChannelMessage(msg.chat_id_,msg.reply_to_message_id_,0)
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "<code>>پیام مورد نظر شما پین شد.</code>", 1, 'html')
db:set(SUDO..'pinned'..msg.chat_id_,msg.reply_to_message_id_)
   end
   end 
			 if text == 'ربات' then
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<b>انلاینم عزیزم!</b>', 1, 'html')
      end
        if text and text:match('چه کسی (%d+)') then
              local id = text:match('چه کسی (%d+)')
            local text = 'برای مشاهده اطلاعات کاربر کلیک کنید.'
			--{"👤 برای مشاهده کاربر کلیک کنید!","Click to view User 👤"}
            tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=36, user_id_=id}}}}, dl_cb, nil)
              end
        if text == "چه کسی" then
        function id_by_reply(extra, result, success)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, '<code>شناسه:</code> [<b>'..result.sender_user_id_..'</b>]\n<code>تعداد پیام های ارسالی:</code> [<b>'..(db:get(SUDO..'total:messages:'..msg.chat_id_..':'..result.sender_user_id_) or 0)..'</b>]', 1, 'html')
        end
         if tonumber(msg.reply_to_message_id_) == 0 then
          else
    bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),id_by_reply)
      end
        end

          end
        end
      end
   -- member
   if text == 'انلاینی' then
          local a = {"<i>آره خیالت راحت *_*</i>","<b>آره عزیزم!</b>"}
          bot.sendMessage(msg.chat_id_, msg.id_, 1,''..a[math.random(#a)]..'', 1, 'html')
      end
	  db:incr("allmsg")
	  if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        if not db:sismember("botgp",msg.chat_id_) then  
            db:sadd("botgp",msg.chat_id_)
			 -- db:incrby("g:pa")
        end
        elseif id:match('^(%d+)') then
        if not db:sismember("usersbot",msg.chat_id_) then
            db:sadd("usersbot",msg.chat_id_)
			--db:incrby("pv:mm")
        end
        else
        if not db:sismember("botgp",msg.chat_id_) then
            db:sadd("botgp",msg.chat_id_)
			 -- db:incrby("g:pa")
        end
     end
    end
	  if text == 'عدد تصادفی' then
         local number = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","43","45","46","47","48","49","50"}  
          bot.sendMessage(msg.chat_id_, msg.id_, 1,'<b>Your Random Number:</b>\n [<code>'..number[math.random(#number)]..'</code>]', 1, 'html')
      end
    if text and msg_type == 'text' and not is_muted(msg.chat_id_,msg.sender_user_id_) then
       if text == "من" then
         local msgs = db:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
         bot.sendMessage(msg.chat_id_, msg.id_, 1, '➖➖➖➖➖➖➖➖\n<b>⚜️شناسه شما</b> 👉 <code>'..msg.sender_user_id_..'</code>\n<b>⚜️تعداد پیامهای شما</b> 👉 <code>'..msgs..'</code>\n➖➖➖➖➖➖➖➖\n👉 @Nice20Team', 1, 'html')
      end
end
end
  -- help 
  if text and text == 'ghelp' then
    if is_sudoers(msg) then
help = [[متن راهنمای مالک ربات ثبت نشده است.]]

  elseif is_owner(msg) then
    help = [[
	<code>>راهنمای مالکین گروه(اصلی-فرعی)</code>

*<b>[/#!]settings</b> --<code>دریافت تنظیمات گروه</code>
*<b>[/#!]setrules</b> --<code>تنظیم قوانین گروه</code>
*<b>[/#!]modset</b> @username|reply|user-id --<code>تنظیم مالک فرعی جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]moddem</b> @username|reply|user-id --<code>حذف مالک فرعی از گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]ownerlist</b> --<code>دریافت لیست مدیران اصلی</code>
*<b>[/#!]managers</b> --<code>دریافت لیست مدیران فرعی گروه</code>
*<b>[/#!]setlink</b> <code>link</code> <code>{لینک-گروه} --تنظیم لینک گروه</code>
*<b>[/#!]link</b> <code>دریافت لینک گروه</code>
*<b>[/#!]kick</b> @username|reply|user-id <code>اخراج کاربر با ریپلی|یوزرنیم|شناسه</code>
<b>-------------------------------</b>
<code>>راهنمای بخش حذف ها</code>
*<b>[/#!]delete managers</b> <code>{حذف تمامی مدیران فرعی تنظیم شده برای گروه}</code>
*<b>[/#!]delete welcome</b> <code>{حذف پیغام خوش آمدگویی تنظیم شده برای گروه}</code>
*<b>[/#!]delete bots</b> <code>{حذف تمامی ربات های موجود در ابرگروه}</code>
*<b>[/#!]delete silentlist</b> <code>{حذف لیست سکوت کاربران}</code>
*<b>[/#!]delete filterlist</b> <code>{حذف لیست کلمات فیلتر شده در گروه}</code>
<b>-------------------------------</b>
<code>>راهنمای بخش خوش آمدگویی</code>
*<b>[/#!]welcome enable</b> --<code>(فعال کردن پیغام خوش آمدگویی در گروه)</code>
*<b>[/#!]welcome disable</b> --<code>(غیرفعال کردن پیغام خوش آمدگویی در گروه)</code>
*<b>[/#!]setwelcome text</b> --<code>(تنظیم پیغام خوش آمدگویی جدید در گروه)</code>
<b>-------------------------------</b>
<code>>راهنمای بخش فیلترگروه</code>
*<b>[/#!]mutechat</b> --<code>فعال کردن فیلتر تمامی گفتگو ها</code>
*<b>[/#!]unmutechat</b> --<code>غیرفعال کردن فیلتر تمامی گفتگو ها</code>
*<b>[/#!]mutechat number(h|m|s)</b> --<code>فیلتر تمامی گفتگو ها بر حسب زمان[ساعت|دقیقه|ثانیه]</code>
<b>-------------------------------</b>
<code>>راهنمای دستورات حالت سکوت کاربران</code>
*<b>[/#!]silentuser</b> @username|reply|user-id <code>--افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]unsilentuser</b> @username|reply|user-id <code>--افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]silentlist</b> <code>--دریافت لیست کاربران حالت سکوت</code>
<b>-------------------------------</b>
<code>>راهنمای بخش فیلتر-کلمات</code>
*<b>[/#!]filter word</b> <code>--افزودن عبارت جدید به لیست کلمات فیلتر شده</code>
*<b>[/#!]unfilter word</b> <code>--حذف عبارت جدید از لیست کلمات فیلتر شده</code>
*<b>[/#!]filterlist</b> <code>--دریافت لیست کلمات فیلتر شده</code>
<b>-------------------------------</b>
<code>>راهنمای دستورات تنظیمات ابر-گروه[فیلترها]</code>
*<b>[/#!]lock|unlock link</b> --<code>(فعال سازی/غیرفعال سازی ارسال تبلیغات)</code>
*<b>[/#!]lock|unlock username</b> --<code>(فعال سازی/غیرفعال سازی ارسال یوزرنیم)</code>
*<b>[/#!]lock|unlock sticker</b> --<code>(فعال سازی/غیرفعال سازی ارسال برچسب)</code>
*<b>[/#!]lock|unlock contact</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  مخاطبین)</code>
*<b>[/#!]lock|unlock english</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  گفتمان(انگلیسی))</code>
*<b>[/#!]lock|unlock persian</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  گفتمان(فارسی))</code>
*<b>[/#!]lock|unlock forward</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  فوروارد)</code>
*<b>[/#!]lock|unlock photo</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  تصاویر)</code>
*<b>[/#!]lock|unlock video</b> --<code>(فعال سازی/غیرفعال سازی فیلتر ویدئو)</code>
*<b>[/#!]lock|unlock gif</b> --<code>(فعال سازی/غیرفعال سازی فیلتر تصاویر-متحرک)</code>
*<b>[/#!]lock|unlock music</b> --<code>(فعال سازی/غیرفعال سازی فیلتر آهنگ(MP3))</code>
*<b>[/#!]lock|unlock audio</b> --<code>(فعال سازی/غیرفعال سازی فیلتر صدا(Voice-Audio))</code>
*<b>[/#!]lock|unlock text</b> --<code>(فعال سازی/غیرفعال سازی فیلتر متن)</code>
*<b>[/#!]lock|unlock keyboard</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  درون-خطی(کیبرد شیشه))</code>
*<b>[/#!]lock|unlock tgservice</b> --<code>(فعال سازی/غیرفعال سازی فیتلر  پیام ورود-خروج افراد)</code>
*<b>[/#!]lock|unlock pin</b> --<code>(مجاز/غیرمجاز کردن پین پیام توسط عضو عادی)</code>
*<b>[/#!]lock|unlock number(h|m|s)</b> --<code>(مجاز/غیرمجاز کردن ارسال پیغام مکرر)</code>
<b>-------------------------------</b>
<code>>راهنمای بخش تنظیم پیغام مکرر</code>
*<b>[/#!]floodmax number</b> --<code>تنظیم حساسیت نسبت به ارسال پیام مکرر</code>
*<b>[/#!]floodtime</b> --<code>تنظیم حساسیت نسبت به ارسال پیام مکرر برحسب زمان</code>
]]
   elseif is_mod(msg) then
    help = [[از متن راهنمای مالکین گروه استفاده کنید.]]
    elseif not is_mod(msg) then
    help = [[متن راهنما برای کاربران عادی ثبت نشده است.]]
    end
   bot.sendMessage(msg.chat_id_, msg.id_, 1, help, 1, 'html')
  end
  end
  
  
  ----end check gp ----------
  end
  end
function tdcli_update_callback(data)
    if (data.ID == "UpdateNewMessage") then
     run(data.message_,data)
elseif data.ID == 'UpdateMessageEdited' then
if not is_mod(msg) and db:get('edit:Lock:'..data.chat_id_) == "lock" then
bot.deleteMessages(data.chat_id_,{[0] = data.message_id_})
end 
    local function edited_cb(extra,result,success)
      run(result,data)
    end
     tdcli_function ({
      ID = "GetMessage",
      chat_id_ = data.chat_id_,
      message_id_ = data.message_id_
    }, edited_cb, nil)
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({
      ID="GetChats",
      offset_order_="9223372036854775807",
      offset_chat_id_=0,
      limit_=20
    }, dl_cb, nil)
end
  end

