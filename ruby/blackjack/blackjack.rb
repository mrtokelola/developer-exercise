class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def score
    total = 0
    num_aces = 0

    # add up each card value
    # assume max value for each ace first
    @cards.each do |card|
      if card.name == :ace
        num_aces += 1
        total += card.value.max
      else
        total += card.value
      end
    end
    # reduce value of each ace if score is too big
    num_aces.times do
      if total > 21
        total -= 10
      end
    end
    # return total
    total
  end

end

class Player
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

  def look_at_cards
    puts "This is the player's cards:"
    p @hand.cards
  end
end

class Dealer
  attr_accessor :hand

  def initialize
    @hand = Hand.new
    @deck = Deck.new
  end

  def deal_hand_to_self
    #give two card to yourself
    @hand.cards << @deck.deal_card
    @hand.cards << @deck.deal_card
  end

  def deal_hand_to_player(player)
    #deal two cards to a givin player
    player.hand.cards << @deck.deal_card
    player.hand.cards << @deck.deal_card
  end

  def show_one_card
    puts "This is the dealer's face up card:"
    p @hand.cards.first
  end

  def deal_hit(player)
    player.hand.cards << @deck.deal_card
    # see if the player is bust...
    score = player.hand.score
    player.look_at_cards
    puts "The player's hand is worth #{score}"
    if score > 21
      puts "Bust!"
    end
  end
end



# Start game (one player)
dealer = Dealer.new
player1 = Player.new
dealer.deal_hand_to_self
dealer.deal_hand_to_player(player1)

# Look at cards
puts "Dealer hand"
dealer.show_one_card
puts

puts "Player 1: Initial hand"
player1.look_at_cards
puts "Player1 Initial Score: #{player1.hand.score}"
puts

# Player 1 asks for a hit
while player1.hand.score < 15
  puts "Player 1: Hit me!"
  dealer.deal_hit(player1)
  puts
end

if player1.hand.score <= 21
  puts "Final hand"
  player1.look_at_cards
  puts "Player1 Score: #{player1.hand.score}"
end




# fix test test_dealt_card_should_not_be_included_in_playable_cards
#   test said card should be included when it shouldn't

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end




