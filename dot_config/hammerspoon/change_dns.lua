-- ============================================================================
-- DNS Manager for Work Network Automation
-- Automatically manages DNS servers based on Wi-Fi network connection
-- ============================================================================

local DNSManager = {}

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

-- ============================================================================
-- Utility Functions
-- ============================================================================

local function executeCommand(cmd)
	local success, output, exitType = hs.execute(cmd)
	if not success then
		hs.logger.new("DNSManager"):e("Command failed: " .. cmd)
		return nil
	end
	return output
end

local function isEmptyDNSResponse(response)
	return response:match("There aren't any DNS Servers") or response:match("There are no DNS Servers")
end

local function parseLines(text)
	local lines = {}
	for line in text:gmatch("[^\r\n]+") do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed and trimmed ~= "" then
			lines[#lines + 1] = trimmed
		end
	end
	return lines
end

local function arrayEquals(arr1, arr2)
	if #arr1 ~= #arr2 then
		return false
	end
	for i = 1, #arr1 do
		if arr1[i] ~= arr2[i] then
			return false
		end
	end
	return true
end

-- ============================================================================
-- DNS Management Functions
-- ============================================================================

function DNSManager.getDNSServers(service)
	if not service or service == "" then
		return {}
	end

	local response = executeCommand('networksetup -getdnsservers "' .. service .. '"')
	if not response or type(response) ~= "string" then
		return {}
	end

	if isEmptyDNSResponse(response) then
		return {}
	end

	return parseLines(response)
end

function DNSManager.setDNSServers(service, servers)
	if not service or service == "" then
		return false
	end

	local cmd = 'networksetup -setdnsservers "' .. service .. '"'
	if #servers == 0 then
		cmd = cmd .. " Empty"
	else
		for i, server in ipairs(servers) do
			cmd = cmd .. " " .. server
		end
	end

	return executeCommand(cmd) ~= nil
end

function DNSManager.removeDNSServers(currentServers, serversToRemove)
	-- Create lookup table for O(1) removal check
	local removeSet = {}
	for _, server in ipairs(serversToRemove) do
		removeSet[server] = true
	end

	local filtered = {}
	for _, server in ipairs(currentServers) do
		if not removeSet[server] then
			filtered[#filtered + 1] = server
		end
	end
	return filtered
end

function DNSManager.mergeDNSServers(priorityServers, existingServers)
	local seen = {}
	local merged = {}

	-- Add priority servers first
	for _, server in ipairs(priorityServers) do
		if not seen[server] then
			merged[#merged + 1] = server
			seen[server] = true
		end
	end

	-- Add existing servers that aren't duplicates
	for _, server in ipairs(existingServers) do
		if not seen[server] then
			merged[#merged + 1] = server
			seen[server] = true
		end
	end

	return merged
end

-- ============================================================================
-- Network Event Handlers
-- ============================================================================

function DNSManager.handleWorkNetworkJoined()
	local currentServers = DNSManager.getDNSServers(CONFIG.wifiService)
	local filteredServers = DNSManager.removeDNSServers(currentServers, CONFIG.googleDNS)

	if not arrayEquals(currentServers, filteredServers) then
		if DNSManager.setDNSServers(CONFIG.wifiService, filteredServers) then
			hs.alert.show(CONFIG.alerts.workDetected)
		else
			hs.alert.show(CONFIG.alerts.error)
		end
	end
end

function DNSManager.handleWorkNetworkLeft()
	local currentServers = DNSManager.getDNSServers(CONFIG.wifiService)
	local mergedServers = DNSManager.mergeDNSServers(CONFIG.googleDNS, currentServers)

	if not arrayEquals(currentServers, mergedServers) then
		if DNSManager.setDNSServers(CONFIG.wifiService, mergedServers) then
			hs.alert.show(CONFIG.alerts.leftWork)
		else
			hs.alert.show(CONFIG.alerts.error)
		end
	end
end

function DNSManager.handleNetworkChange()
	local newSSID = hs.wifi.currentNetwork()

	-- Avoid processing the same network change multiple times
	if state.currentSSID == newSSID then
		return
	end

	-- Cancel any pending debounce timer
	if state.debounceTimer then
		state.debounceTimer:stop()
		state.debounceTimer = nil
	end

	-- Debounce network changes to avoid rapid switching
	state.debounceTimer = hs.timer.doAfter(CONFIG.debounceTime, function()
		-- Only process if the network actually changed from last processed state
		if state.currentSSID == state.lastSSID then
			state.debounceTimer = nil
			return
		end

		if state.currentSSID == CONFIG.workSSID and state.lastSSID ~= CONFIG.workSSID then
			DNSManager.handleWorkNetworkJoined()
		elseif state.currentSSID ~= CONFIG.workSSID and state.lastSSID == CONFIG.workSSID then
			DNSManager.handleWorkNetworkLeft()
		end

		-- Update state tracking
		state.lastSSID = state.currentSSID
		state.debounceTimer = nil
	end)

	-- Update current SSID immediately for duplicate detection and debounced processing
	state.currentSSID = newSSID
end

-- ============================================================================
-- Module Initialization
-- ============================================================================

function DNSManager.start()
	if state.wifiWatcher then
		state.wifiWatcher:stop()
	end

	state.wifiWatcher = hs.wifi.watcher.new(DNSManager.handleNetworkChange)
	state.wifiWatcher:start()

	-- Initial network check
	state.currentSSID = hs.wifi.currentNetwork()
	hs.logger.new("DNSManager"):i("DNS Manager started")
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

	hs.logger.new("DNSManager"):i("DNS Manager stopped")
end

-- Start the DNS manager
DNSManager.start()

-- Export for testing or manual control
return DNSManager
