local ADDON = LibStub("AceAddon-3.0"):GetAddon("Inventorian")
local InvLevel = ADDON:NewModule('InventorianLevel')

function InvLevel:Update()
	if self.ItemLevel then
		self.ItemLevel:Hide()
	end	

	--saved items do not contain information about the current level of items
	if GetUnitName('player') ~= self.container:GetParent():GetPlayerName() then
		return
	end
	
	local _, _, _, quality, _, _, link, _, itemID = self:GetInfo()
	--slot is empty or not loaded, dont do nothing
	if not itemID then
		return
	end

	local function Check(self, quality, itemID)
		local _, _, _, _, _, itemClass = GetItemInfoInstant(itemID)
		
		if (quality and quality or 0) >= Enum.ItemQuality.Uncommon and (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor) then
			local itemLevel = C_Item.GetCurrentItemLevel( ItemLocation:CreateFromBagAndSlot(self.bag, self.slot) )
			local r, g, b, hex = GetItemQualityColor(quality)
			self.ItemLevel:SetFormattedText('|c%s%s|r', hex, itemLevel or '?')
			self.ItemLevel:Show()
		end
	end
	
	if quality then
		Check(self, quality, itemID)
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
