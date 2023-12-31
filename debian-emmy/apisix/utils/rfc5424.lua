--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
local LOG_EMERG     = 0       --  system is unusable
local LOG_ALERT     = 1       --  action must be taken immediately
local LOG_CRIT      = 2       --  critical conditions
local LOG_ERR       = 3       --  error conditions
local LOG_WARNING   = 4       --  warning conditions
local LOG_NOTICE    = 5       --  normal but significant condition
local LOG_INFO      = 6       --  informational
local LOG_DEBUG     = 7       --  debug-level messages

local LOG_KERN      = 0       --  kernel messages
local LOG_USER      = 1       --  random user-level messages
local LOG_MAIL      = 2       --  mail system
local LOG_DAEMON    = 3       --  system daemons
local LOG_AUTH      = 4       --  security/authorization messages
local LOG_SYSLOG    = 5       --  messages generated internally by syslogd
local LOG_LPR       = 6       --  line printer subsystem
local LOG_NEWS      = 7       --  network news subsystem
local LOG_UUCP      = 8       --  UUCP subsystem
local LOG_CRON      = 9       --  clock daemon
local LOG_AUTHPRIV  = 10      --  security/authorization messages (private)
local LOG_FTP       = 11      --  FTP daemon
local LOG_LOCAL0    = 16      --  reserved for local use
local LOG_LOCAL1    = 17      --  reserved for local use
local LOG_LOCAL2    = 18      --  reserved for local use
local LOG_LOCAL3    = 19      --  reserved for local use
local LOG_LOCAL4    = 20      --  reserved for local use
local LOG_LOCAL5    = 21      --  reserved for local use
local LOG_LOCAL6    = 22      --  reserved for local use
local LOG_LOCAL7    = 23      --  reserved for local use

local Facility = {
    KERN = LOG_KERN,
    USER = LOG_USER,
    MAIL = LOG_MAIL,
    DAEMON = LOG_DAEMON,
    AUTH = LOG_AUTH,
    SYSLOG = LOG_SYSLOG,
    LPR = LOG_LPR,
    NEWS = LOG_NEWS,
    UUCP = LOG_UUCP,
    CRON = LOG_CRON,
    AUTHPRIV = LOG_AUTHPRIV,
    FTP = LOG_FTP,
    LOCAL0 = LOG_LOCAL0,
    LOCAL1 = LOG_LOCAL1,
    LOCAL2 = LOG_LOCAL2,
    LOCAL3 = LOG_LOCAL3,
    LOCAL4 = LOG_LOCAL4,
    LOCAL5 = LOG_LOCAL5,
    LOCAL6 = LOG_LOCAL6,
    LOCAL7 = LOG_LOCAL7,
}

local Severity = {
    EMEGR = LOG_EMERG,
    ALERT = LOG_ALERT,
    CRIT = LOG_CRIT,
    ERR = LOG_ERR,
    WARNING = LOG_WARNING,
    NOTICE = LOG_NOTICE,
    INFO = LOG_INFO,
    DEBUG = LOG_DEBUG,
}

local log_util = require("apisix.utils.log-util")
local ipairs = ipairs
local str_format = string.format

local _M = { version = 0.1 }


function _M.encode(facility, severity, hostname, appname, pid, msg, structured_data)
    local pri = (Facility[facility] * 8 + Severity[severity])
    local t = log_util.get_rfc3339_zulu_timestamp()
    if not hostname then
        hostname = "-"
    end

    if not appname then
        appname = "-"
    end

    local structured_data_str = "-"

    if structured_data then
        structured_data_str = "[logservice"
        for _, sd_param in ipairs(structured_data) do
            structured_data_str = structured_data_str .. " " .. sd_param.name
                                  .. "=\"" .. sd_param.value .. "\""
        end
        structured_data_str = structured_data_str .. "]"
    end

    return str_format("<%d>1 %s %s %s %d - %s %s\n", pri, t, hostname,
                    appname, pid, structured_data_str, msg)
end

return _M
