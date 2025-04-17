--!strict
local MarketplaceService = game:GetService('MarketplaceService')

--> Main
local Marketplace = {}

--> Methods

--[=[

	Check if a player owns a gamepass
	@param UserId number
	@param PassId number
	@return boolean

]=]
function Marketplace.HasPass(UserId : number, PassId : number) : boolean
	return MarketplaceService:UserOwnsGamePassAsync(UserId, PassId)
end


--[=[

	Prompt a user to purchase a gamepass
	@public
	@param player Player
	@param PassId number

]=]
function Marketplace.PromptPass(player : Player, PassId : number)
	if Marketplace.HasPass(player.UserId, PassId) == true then return end
	MarketplaceService:PromptGamePassPurchase(player, PassId)
end

--[=[

	Prompt a user to purchase a developer product
	@public
	@param player Player
	@param ProductId number

]=]
function Marketplace.PromptProduct(player : Player, ProductId : number)
	MarketplaceService:PromptProductPurchase(player, ProductId)
end

--[=[

	Prompt a user to purchase Premium membership
	@public
	@param player Player

]=]
function Marketplace.PromptPremiumPurchase(player : Player)
	if player.MembershipType == Enum.MembershipType.Premium then return end
	MarketplaceService:PromptPremiumPurchase(player)
end

--[=[

	Prompt a user to complete a bulk purchase
	@public
	@param player Player
	@param items table
	@param options table

]=]
function Marketplace.BulkPurchase(player : Player, items : {number}, options : {any}?)
	MarketplaceService:PromptBulkPurchase(player, items, options or {})
end

--[=[

	Prompt a user to purchase a subscription
	@public
	@param player Player
	@param SubscriptionId string

]=]
function Marketplace.PromptSubscription(player : Player, SubscriptionId : string)
	MarketplaceService:PromptSubscriptionPurchase(player, SubscriptionId)
end

--[=[

	Prompt a user to cancel a subscription
	@public
	@param player Player
	@param SubscriptionId string

]=]
function Marketplace.PromptSubscriptionCancel(player : Player, SubscriptionId : string)
	MarketplaceService:PromptCancelSubscription(player, SubscriptionId)
end

--> return
return Marketplace
