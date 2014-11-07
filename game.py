

        
class Game:
    
    def __init__(self,n):
        print "welcome to black jack"
        n = input("how many players would you like to have? (max of 8)")
        self.chips = [1000 for i in range(n)]
        self.stillPlaying = [True for i in range(n)]
        self.playerHands = [None for i in range(n)]
        self.dealerHand = None
        self.deck = Deck()


    # handles io with the player
    def queryPlayer():
        pass

    def startGame():
        pass

    def dealHand():
        pass

    def placeBets():
        pass

    def isValidBet(amt,playerId):
        pass

     
class Deck:
    '''represents one or more decks of cards (casinos generally use more than a single deck of cards for a blackjack table'''
    cardValIds = [i for i in range(1,14)] # each card id corresponds to a different card 
    def __init__(self,n):
        self.cards = []
        for i in range(4*n):
            self.cards.extend(cardValIds)

        
        

    @staticmethod
    def getValue(val):
       if val > 

class Hand:
    
    def __init__(self,n1,n2):
        self.cards = [n1,n2]

    # None -> List[int]
    def valueOfHand(self):
        numAces = 0
        currSum = 0
        for val in self.cards:
            if val == 0:
                numAces += 1
            elif val > 10:
                currSum += 10
            else:
                currSum += val

        if numAces == 0:
            return [currSum]
        else:
            aceVals = [numAces]
            for i in range(numAces):
                aceVals.append(numAces + i * 9)
            return map(lambda x: x + currSum, aceVals)
    
    def hit(self,n):
        pass

    def canDoubleDown(self):
        return len(selfself.cards) == 2
    
    def doubleDown(self):
        pass

    def canSplit(self):
        return len(selfself.cards) == 2 and self.cards[0] == self.cards[1]
    
    def split(self):
        pass

    def isBusted(self):
        pass

    def printPossibleActions(self):
        pass
        

def isValidValue(amt, playerID):
    pass


