class Game
	ActionStrings = { :hit => "Hit: take a card.",
					  :stand => "Stand: end your turn.",
					  :double => "Double: double your wager, take one card, and end your turn.",
					  :bet => "Bet: Set your wager on the outcome of this round."
					}
	
	def initialize
		@money = 500
	end
	
	class Card
		attr_reader :suit, :value
		SuitUnicodeStrings = ["\342\231\240",
							  "\342\231\243",
							  "\342\231\245",
							  "\342\231\246" ]
		def initialize (index)
			@suit = (index / 13)
			@value = (index % 13) + 1
		end
		
		def to_s
			ret =
			case @value
			when 1 then "A"
			when 2..10 then @value.to_s
			when 11 then "J"
			when 12 then "Q"
			when 13 then "K"
			end
			ret += SuitUnicodeStrings[@suit]
		end
	end
	
	class Hand < Array
		def to_s
			join(" ") + " [#{value} points]"
		end
		
		def value
			val = 0
			aces = 0
			for card in self
				case card.value
				when 1 then
					val += 1
					aces += 1
				when 2..9
					val += card.value
				when 10..13
					val += 10
				end
			end
			while val <= 11 and aces > 0
				val += 10
				aces -= 1
			end
			val
		end
		
		def bust
			value > 21
		end
	end
	
	class Deck < Array
		def initialize
			for i in 0..51
				push Card.new(i)
			end
		end
	end
	
	def reset_round
		srand()
		@deck = Deck.new
		@deck.shuffle!
		@dealer_hand = []
		@player_hand = []
		@pot = 0
		@doubled = false
	end
	
	def display_state
		if @dealer_hand.size > 0
			puts "\nThe dealer's (revealed) cards are #{@dealer_hand}" 
			puts "Your cards are #{@player_hand}\n\n" if @player_hand.size > 0
		else
			puts "You have $#{@money} left to bet." 
		end
	end
	
	def main_game_loop
		puts "Welcome to blackjack.rb, the ultimate in take home interview programming assignments."
		reset_round
		while true
			display_state
			do_input
		end
	end
	
	def bet
		while @pot < 1 or @pot > 100
			puts "Choose your wager. You may bet up to $#{[100, @money].min}."
			@pot = gets.chomp.to_i
		end
		@money -= @pot
		@dealer_hand = Hand.new([@deck.pop])
		@player_hand = Hand.new([@deck.pop, @deck.pop])
	end
	
	def hit
		card = @deck.pop
		puts "You drew a #{card}"
		@player_hand.push card
		if @player_hand.bust
			puts "Your hand (#{@player_hand}) busted."
			lose
		end
	end
	
	def stand
		puts "You stand with #{@player_hand}" 
		@dealer_hand.push @deck.pop
		puts "The dealer reveals #{@dealer_hand}" 
		while @dealer_hand.value < 17
			card = @deck.pop
			@dealer_hand.push card
			puts "The dealer hits a #{card}. His hand is now #{@dealer_hand}"
		end
		if @dealer_hand.bust
			puts "The dealer busts!"
			win
		elsif @dealer_hand.value < @player_hand.value
			win
		elsif @dealer_hand.value == @player_hand.value
			tie 
		else
			lose
		end
	end
	
	def double
		increase = [@money, @pot].min
		@pot += increase
		@money -= increase
		@doubled = true
		hit
	end
	
	def win
		puts "You win $#{@pot}!"
		@money += @pot * 2
		reset_round
	end
	
	def lose
		puts "You lose $#{@pot}."
		if @money == 0
			puts "You've run out of money! Forever shamed by your peers, you are forced to leave the casino, and your family, forever."
			exit
		end
		reset_round
	end
	
	def tie
		puts "You tied with the dealer, breaking even."
		@money += @pot
		reset_round
	end
	
	def game_over
		exit
	end
	
	def get_actions
		return [:bet] if @player_hand.size == 0
		opts = [:stand]
		opts.push :hit unless @doubled
		opts.push :double if @player_hand.size == 2
		return opts
	end
	
	def do_input
		actions = get_actions
		if actions.size == 1
			puts ActionStrings[actions.first]
			self.send actions.first
		else
			input = 0
			while input < 1 or input > actions.length
				actions.each_index { |i| puts "[#{i+1}] #{ActionStrings[actions[i]]}" }
				puts "Enter your choice: "
				input = gets.chomp.to_i
			end
			self.send actions[input-1]
		end
	end
end

game = Game.new
game.main_game_loop