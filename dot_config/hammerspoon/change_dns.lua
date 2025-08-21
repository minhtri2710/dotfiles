-- ============================================================================
-- DNS Manager for Work Network Automation (Refactored)
-- - Improved logging, command handling, and debounce logic
-- - Preserves original behavior: remove Google DNS on work SSID, restore on leave
-- ============================================================================

local DNSManager = {}

local logger = hs.logger.new("DNSManager")

-- Configuration
local CONFIG = {
	workSSID = "VietUnion_5.0GHz",
	googleDNS = { "8.8.8.8", "8.8.4.4" },
	wifiService = hs.network.interfaceName(),
	alerts = {
		workDetected = "Work Wi-Fi detected - removed Google DNS",
		leftWork = "Left work - added Google DNS",
		error = "DNS configuration error occurred",
	},
	-- Debounce time to prevent rapid consecutive changes
	debounceTime = 2.0,
}

-- State management
local state = {
	wifiWatcher = nil,
	currentSSID = nil,
	lastSSID = nil,
	debounceTimer = nil,
}

-- -----------------------------------------------------------------------------
-- Utilities
-- -----------------------------------------------------------------------------
local function runCommand(cmd)
	-- Execute a shell command and return output or nil on failure
	local output, success = hs.execute(cmd)
	if not success then
		logger:e("Command failed: " .. cmd)
		return nil
	end
	return output
end

local function isEmptyDNSResponse(response)
	if type(response) ~= "string" then
		return false
	end
	return response:find("There aren't any DNS Servers") or response:find("There are no DNS Servers")
end

local function parseLines(text)
	local out = {}
	for line in text:gmatch("[^\r\n]+") do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed ~= "" then
			out[#out + 1] = trimmed
		end
	end
	return out
end

local function tablesEqual(a, b)
	if #a ~= #b then
		return false
	end
	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end
	return true
end

-- -----------------------------------------------------------------------------
-- DNS helpers
-- -----------------------------------------------------------------------------
function DNSManager.getDNSServers(service)
	if not service or service == "" then
		return {}
	end

	local resp = runCommand('networksetup -getdnsservers "' .. service .. '"')
	if not resp or type(resp) ~= "string" then
		return {}
	end
	if isEmptyDNSResponse(resp) then
		return {}
	end
	return parseLines(resp)
end

function DNSManager.setDNSServers(service, servers)
	if not service or service == "" then
		return false
	end

	local cmd = 'networksetup -setdnsservers "' .. service .. '"'
	if #servers == 0 then
		cmd = cmd .. " Empty"
	else
		cmd = cmd .. " " .. table.concat(servers, " ")
	end

	local ok = runCommand(cmd) ~= nil
	if not ok then
		logger:w("Failed to set DNS servers for " .. tostring(service))
	end
	return ok
end

function DNSManager.removeDNSServers(current, toRemove)
	local removeSet = {}
	for _, s in ipairs(toRemove) do
		removeSet[s] = true
	end

	local filtered = {}
	for _, s in ipairs(current) do
		if not removeSet[s] then
			filtered[#filtered + 1] = s
		end
	end
	return filtered
end

function DNSManager.mergeDNSServers(priority, existing)
	local seen = {}
	local merged = {}
	for _, s in ipairs(priority) do
		if not seen[s] then
			merged[#merged + 1] = s
			seen[s] = true
		end
	end
	for _, s in ipairs(existing) do
		if not seen[s] then
			merged[#merged + 1] = s
			seen[s] = true
		end
	end
	return merged
end

-- -----------------------------------------------------------------------------
-- Handlers
-- -----------------------------------------------------------------------------
function DNSManager.handleWorkNetworkJoined()
	local current = DNSManager.getDNSServers(CONFIG.wifiService)
	local filtered = DNSManager.removeDNSServers(current, CONFIG.googleDNS)

	if not tablesEqual(current, filtered) then
		if DNSManager.setDNSServers(CONFIG.wifiService, filtered) then
			hs.alert.show(CONFIG.alerts.workDetected)
			logger:i("Removed prioritized DNS servers on work SSID")
		else
			hs.alert.show(CONFIG.alerts.error)
			logger:e("Failed to remove prioritized DNS servers on work SSID")
		end
	end
end

function DNSManager.handleWorkNetworkLeft()
	local current = DNSManager.getDNSServers(CONFIG.wifiService)
	local merged = DNSManager.mergeDNSServers(CONFIG.googleDNS, current)

	if not tablesEqual(current, merged) then
		if DNSManager.setDNSServers(CONFIG.wifiService, merged) then
			hs.alert.show(CONFIG.alerts.leftWork)
			logger:i("Restored prioritized DNS servers after leaving work SSID")
		else
			hs.alert.show(CONFIG.alerts.error)
			logger:e("Failed to restore prioritized DNS servers after leaving work SSID")
		end
	end
end

function DNSManager.handleNetworkChange()
	local newSSID = hs.wifi.currentNetwork()
	-- Short-circuit if nothing changed
	if newSSID == state.currentSSID then
		return
	end

	-- update current and debounce processing
	state.currentSSID = newSSID
	if state.debounceTimer then
		state.debounceTimer:stop()
		state.debounceTimer = nil
	end

	state.debounceTimer = hs.timer.doAfter(CONFIG.debounceTime, function()
		-- If the processed SSID matches last processed, nothing to do
		if state.currentSSID == state.lastSSID then
			state.debounceTimer = nil
			return
		end

		if state.currentSSID == CONFIG.workSSID and state.lastSSID ~= CONFIG.workSSID then
			DNSManager.handleWorkNetworkJoined()
		elseif state.currentSSID ~= CONFIG.workSSID and state.lastSSID == CONFIG.workSSID then
			DNSManager.handleWorkNetworkLeft()
		end

		state.lastSSID = state.currentSSID
		state.debounceTimer = nil
	end)
end

-- -----------------------------------------------------------------------------
-- Lifecycle
-- -----------------------------------------------------------------------------
function DNSManager.start()
	if state.wifiWatcher then
		state.wifiWatcher:stop()
	end
	state.wifiWatcher = hs.wifi.watcher.new(function()
		DNSManager.handleNetworkChange()
	end)
	state.wifiWatcher:start()
	state.currentSSID = hs.wifi.currentNetwork()
	logger:i("DNS Manager started")
	-- Trigger a check immediately (debounced)
	DNSManager.handleNetworkChange()
end

function DNSManager.stop()
	if state.wifiWatcher then
		state.wifiWatcher:stop()
		state.wifiWatcher = nil
	end
	if state.debounceTimer then
		state.debounceTimer:stop()
		state.debounceTimer = nil
	end
	logger:i("DNS Manager stopped")
end

-- Auto-start
DNSManager.start()

return DNSManager
