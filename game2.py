from random import shuffle
class Game:
    def __init__(self,numPlayers):
        self.playerArray =[Player(self) for i in range(numPlayers)]
        self.deck = new Deck()
        self.startHand()


    def startHand():
        for i,player in enumerate(self.playerArray):
            pass
    def collectBets():
        for player in self.playerArray:
            player.
    def dealHand(self):
        for i,player in enumerate(self.playerArray):
            if player.stillIn:
                player.hand = self.deck.dealHand() #CHECK THIS
        
class Player:
    def __init__(self,game):
        self.chips = 1000
        self.hand = None
        self.bet = 0
        self.stillIn = True
        self.game = game
       
    def canMakeBet(n):
        return self.chips >= n

    def getAction(n):
        pass



class Deck:
    '''represents one or more decks of cards (casinos generally use more than a single deck of cards for a blackjack table, by default, 6 decks'''
    cardValIds = [i for i in range(1,14)] # each card id corresponds to a different card 
    def __init__(self,n = 6):
        self.cards = []
        for i in range(4*n):
            self.cards.extend(cardValIds)
        self.shuffle()

    def getHand():
        out = [self.cards.pop(),self.cards.pop()]

    def shuffle():
        random.shuffle(self.cards)
        
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
        

a = Game()
