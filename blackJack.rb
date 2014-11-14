#!/usr/bin/ruby1.8
# require 'test/unit'


class Game
	
	@@validActions = ["stand","double","hit","split"]
	

	def initialize()
		@players = []
		@deck = Deck.new()
		@dealersHand = nil
		@dealerValue = 0
		@numPlayers = -1
		@numHands = {}
		
		while true
			puts "How many players (max. 8)" + "\n"
			begin
				num = Integer(gets)
				if num > 8 or num < 1
					puts "please enter a valid number of players" + "\n"
				else
					@numPlayers = num
					break
				end
			rescue
				puts "please enter a valid number of players" + "\n"
				next
			end
		end
		for i in 1..@numPlayers
			@players.push(Player.new(i))
		end
	end

	def getBets()
		for player in @players
			while true
				puts player.getID() + ", please make a bet (you have " + String(player.getNumChips()) + " chips)" + "\n"
				begin
					bet = Integer(gets)
					if bet <= player.getNumChips and bet > 0
						player.setCurrBet(bet)
						break
					else
						puts "please enter a valid amount to bet" + "\n"
						next
					end
				rescue
					puts "Invalid bet amount. Please enter a valid bet amount" + "\n"
					next
				end
			end
		end
	end 

	def dealHands()
	 	for player in @players
	 		handToAdd = @deck.getHand()
	 		# puts "hand to add: " + String(handToAdd)
	 		player.addHand(handToAdd)
	 		@numHands[player] = 1
	 	end
	 	@dealersHand = @deck.getHand()
	end

	def getPlayerActions()
		
		for player in @players

			for hand in player.getHands()
				puts "Dealer shows a " + @dealersHand.printHand()[0,1] + "\n"
				puts player.getID() + ", What would you like to do? (type h for all possible options)" + "\n"
				while true
					puts "Your current hand: " + hand.printHand() + " (" + String(hand.getValue) + ")" +  "\n"
					if hand.isBusted()
						puts "BUSTED" + "\n"
						break
					end
					desiredAction = gets.split.join('    ') # gets rid of new lines
					if desiredAction == "h"
						puts @@validActions.join("    ") + "\n"
					elsif !@@validActions.include?(desiredAction)
						puts "please enter a valid action" + "\n"
					elsif desiredAction == "hit"
						hand.addCard()
					elsif desiredAction == "stand"
						break
					elsif desiredAction == "split"
						hand.printHand()
						if !hand.canSplit()
							puts "this hand is not valid for splitting. Pick another action" + "\n"
						elsif (@numHands[player] + 1) * player.getCurrBet() > player.getNumChips()
							puts "You don't have enough chips to split. Pick another action" + "\n"
						else
							@numHands[player] = @numHands[player] + 1
							h1,h2 = hand.split()
							player.getHands << h1 << h2
							break
						end
					elsif desiredAction == "double"
						if !hand.canDoubleDown()
							puts "this hand can't be doubled down. Pick another action" + "\n"
						elsif (@numHands[player] + 1) * player.getCurrBet() > player.getNumChips()
							puts "You don't have enough chips to double down. Pick another action" + "\n"
						else
							@numHands[player] = @numHands[player] + 1
							hand.doubleDown()
							puts "Your hand after doubling down: " + hand.printHand() + "\n"
							break
						end
					end
				end
			end
		end
	end
	
	def getDealerCards()
		while @dealersHand.getValue() < 17
			@dealersHand.addCard()
		end
		if @dealersHand.getValue() <= 21
			puts "Dealers final hand is " + @dealersHand.printHand
		else 
			puts "Dealers busts with " + @dealersHand.printHand
		end
	end

	def moveChips()
		puts "\n" + "Dealers hand: " + @dealersHand.printHand()  + "(" + String(@dealersHand.getValue()) + ")"
		for player in @players
			puts player.getID() + "'s hands"
			for hand in player.getHands()
				if hand.isSplit
					next 
				end
				mult = if hand.isDoubledDown then 2 else 1 end
				changeInChips = 0

				if hand.isBusted()
					changeInChips = -1 * mult * player.getCurrBet
				elsif @dealersHand.isBusted()
					changeInChips = mult * player.getCurrBet
				elsif hand.getValue == @dealersHand.getValue
					nil
				elsif hand.getValue < @dealersHand.getValue
					changeInChips = -1 * mult * player.getCurrBet
				else
					changeInChips = mult * player.getCurrBet
				end
				puts "\t" + hand.printHand() + " (" + String(hand.getValue) + ")" + "change in chips: " +  String(changeInChips)
				player.modifyChips(changeInChips)
			end
		end
	end
	
	def finishRound()
		@players = @players.select{|player| player.getNumChips() > 0}
		for player in @players
			player.clearHands()
		end
		if @players.length() == 0
			puts "all players have busted out. Game Over."
			exit
		end
		if @deck.timeToRefill()
			@deck = Deck.new()
		end
	end

	def startGame()
		while @numPlayers > 0
			getBets()
			dealHands()
			getPlayerActions()
			getDealerCards()
	 		moveChips()
	 		finishRound()
		end
	end
end

class Player
	def initialize(playerId)
		@playerId = playerId
		@chips = 1000
		@hands = []
		@currBet = 0
	end

	def stillIn()
		return chips > 0
	end

	def modifyChips(n)
		@chips += n
	end

	def getNumChips()
		return @chips
	end
    
	def getHands()
		return @hands
	end

	def addHand(hand)
		@hands.push(hand)
	end

	def clearHands()
		@hands = []
	end

	def getCurrBet()
		return @currBet
	end

	def setCurrBet(n)
		@currBet = n
	end

	def getID()
		return "Player " + String(@playerId)
	end

	def printHands()
		for hand in @hands
			hand.printHand()
		end

	end
		
end

class Hand
	def initialize(deck,cards = [])
		@sourceDeck = deck
		@cardValueIds = cards
		@isDoubledDown = false
		@isSplit = false
	end
	
	def self.splitHand(deck,handToSplit)
		hand1 = Hand.new(deck)
		hand2 = Hand.new(deck)
		hand1.addCard(handToSplit[0])
		hand1.addCard()
		hand2.addCard(handToSplit[1])
		hand2.addCard()
		return hand1,hand2
	end



	def getValue()
		# puts String(@cardValueIds.join(","))
		numAces = 0
		currSum = 0
		for card in @cardValueIds
			if card == 1
				numAces += 1
				currSum += 1
			elsif card <= 10
				currSum += card
			else
				currSum += 10
			end
		end
		if numAces == 0
			return currSum
		else
			out = [currSum]
			for i in 1..numAces
				out.push(i * 10 + currSum)
			end
			if out.min() > 21
				return out.min()
			else
				return out.select{|number| number <= 21}.max()
			end
		end
	end

	def addCard(cardToAdd = nil)
		if cardToAdd == nil
			@cardValueIds << @sourceDeck.getCard()
		else
			@cardValueIds << cardToAdd
		end
	end

	def doubleDown()
		@isDoubledDown = true
		addCard()
	
	end

	def canDoubleDown()
		return @cardValueIds.length() == 2 
	end

	def split()
		@isSplit = true
		hand1,hand2 = Hand.splitHand(@sourceDeck,@cardValueIds)
		return hand1,hand2

	end

	def canSplit()
		if @cardValueIds.length() == 2 and (@cardValueIds[0] == @cardValueIds[1] or getValue() == 20)
			return true
		else
			return false
		end
	end

	def isBusted()
		if getValue() > 21
			return true
		return false
		end
	end

	def printHand()
		return @cardValueIds.map{|card| Deck.getCardName(card)}.join(",")
	end

	def isDoubledDown()
		return @isDoubledDown
	end

	def isSplit()
		return @isSplit
	end



end

class Deck
	
	@@cardNames = {1=>"A", 2=>"2", 3=>"3", 4=>"4", 5=>"5",6=>"6",7=>"7",8=>"8",9=>"9",10=>"10",11=>"J",12=>"Q",13=>"K"}
	@@valueIds = [1,2,3,4,5,6,7,8,9,10,11,12,13] # each corresponds to a single card value (A=1,2=2...13=K)

	def self.getCardName(id)
		# puts "looking for id: "
		# puts Integer(id)
		begin 
			id = Integer(id) # in case a string was passed in
			if @@cardNames.key?(id)
				return @@cardNames.fetch(id)
			else
				puts "INVALID VALUE ID" + "\n"
				return nil
			end
		rescue
			puts "INVALID VALUE ID" + "\n"
			return nil
		end
	end
	
	def initialize()
		@cards = []
		# simulating 2 full decks
		for i in 0...8
			@cards.concat(@@valueIds)
		end
		@cards.shuffle!()
	end

	def timeToRefill()
		if @cards.length() < 26
			return true
		end
		return false
	end

	def getCardsLeft()
		return @cards
	end

	def getCard()
		return @cards.pop()
	end

	def getHand()
		return Hand.new(self,[@cards.pop(),@cards.pop()])
	end

end

def testGenValue()
	d = Deck.new()

	a = Hand.new(d,[1,1])
	if a.getValue() != 12
		puts "1,1 doesn't give the value 12" + "\n"
		puts "instead, it gives the value: " + String(a.getValue().join(",")) + "\n"
	end

	b = Hand.new(d,[2,2])
	if b.getValue() != 4
		puts "2,2 doesn't give the value 4" + "\n"
		puts "instead, it gives the value: " + String(b.getValue().join(",")) + "\n"
	end
		
end
testGenValue()
a = Game.new()
a.startGame()
