local ADDON = LibStub("AceAddon-3.0"):GetAddon("Inventorian")
local InvLevel = ADDON:NewModule('InventorianLevel')

function InvLevel:Update()
	local item  = self

	if item:IsVisible() then
		item.ItemLevel:Hide()
	end	
	
	local _, _, _, quality, _, _, link, _, itemID = item:GetInfo()
	--slot is empty, dont do nothing
	if not itemID then return end
	
	local function Check(item, quality, itemID)
		local _, _, _, _, _, itemClass = GetItemInfoInstant(itemID)
		if (quality and quality or 0) >= Enum.ItemQuality.Uncommon and (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor) then
			local itemLoc = ItemLocation:CreateFromBagAndSlot(item.bag, item.slot)
			local itemLevel = C_Item.GetCurrentItemLevel(itemLoc)
			local r, g, b, hex = GetItemQualityColor(quality)
			item.ItemLevel:SetFormattedText('|c%s%s|r', hex, itemLevel or '?')
			item.ItemLevel:Show()
		end
	end
	
	if quality then
		Check(item, quality, itemID)
	else
		local _item = Item:CreateFromBagAndSlot(item.bag, item.slot)
		_item:ContinueOnItemLoad(function()
			quality = select(4, item:GetInfo())
			Check(item, quality, itemID)
		end)
	end
	
	
end

function InvLevel:WrapItemButton(item)

	if not item.ItemLevel then
		local overlayFrame = CreateFrame("FRAME", nil, item)
		overlayFrame:SetFrameLevel(4)
		overlayFrame:SetAllPoints()
		
		item.ItemLevel = overlayFrame:CreateFontString('$parentItemLevel', 'ARTWORK')
		item.ItemLevel:SetPoint('TOPLEFT', 0, -2)
		item.ItemLevel:SetFont('Fonts\\ARIALN.TTF', 14, 'OUTLINE, THICK')
		item.ItemLevel:SetShadowColor(BLACK_FONT_COLOR:GetRGBA())
		item.ItemLevel:SetShadowOffset(2, -1)
		item.ItemLevel:SetJustifyH('LEFT')
	end
	
	hooksecurefunc(item, "Update", InvLevel.Update)

	return item
end
hooksecurefunc(ADDON.Item, "WrapItemButton", InvLevel.WrapItemButton)
