require 'minitest/autorun'

module Searchable
  def where(options)
    # options are given (like search for :name => 'The Wolf')
    # self is the array itself (like [@boris, @charles, @wolf, @glen])
    # check each item in the array
    #   compare each key/value from options to each item
    #   (check if item[:name] matches options[:name].request_hit)


     return self.select do |item|
       match = true
       options.each do |key, value|
         if value.instance_of? Regexp
           if !item[key].match?(value)
             match = false
           end
         else
           if item[key] != value
             match = false
           end
         end
       end
       match
     end

    # result = []
    # self.each do |item|
    #   match = true
    #   options.each do |key, value|
    #     if value.instance_of? Regexp
    #       if !item[key].match?(value)
    #         match = false
    #       end
    #     else
    #       if item[key] != value
    #         match = false
    #       end
    #     end
    #   end
    #   if match
    #     result << item
    #   end
    # end
    # return result


  end
end

class Array
  include Searchable
end


class WhereTest < Minitest::Test
  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end

