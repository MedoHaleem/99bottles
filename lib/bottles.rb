class CountdownSong
  attr_reader :verse_template, :max, :min

  def initialize(verse_template: , max: 99999, min: 0)
    @verse_template = verse_template
    @max, @min = max, min
  end

  def song
    verses(max, min)
  end

  def verses(upper, lower)
    upper.downto(lower).collect { |i| verse(i) }.join("\n")
  end

  def verse(number)
    verse_template.lyrics(number)
  end

end

class BottleVerse
  attr_reader :bottle_number

  def self.lyrics(number)
    new(BottleNumber.for(number)).lyrics
  end

  def initialize(bottle_number )
    @bottle_number  = bottle_number
  end

  def lyrics
    "#{bottle_number} ".capitalize + "of beer on the wall, " +
      "#{bottle_number} of beer.\n" +
      "#{bottle_number.action}, " +
      "#{bottle_number.successor} of beer on the wall.\n"
  end
end

class BottleNumber
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def self.for(number)
    registry.find {|candidate| candidate.handles? number }.new(number)
  end

  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend candidate
  end

  BottleNumber.register(self)

  def self.handles?(number)
    true
  end

  def to_s
    "#{quantity} #{container}"
  end

  def successor
    BottleNumber.for(number - 1)
  end

  def action
    if number.zero?
      "Go to the store and buy some more"
    else
      "Take #{pronoun} down and pass it around"
    end
  end

  def quantity
    if number == 0
      "no more"
    else
      number.to_s
    end
  end

  def pronoun
    if number == 1
      "it"
    else
      "one"
    end
  end

  def container
    if number == 1
      "bottle"
    else
      "bottles"
    end
  end
end

class BottleNumber1 < BottleNumber
  BottleNumber.register(self)
  def container
    "bottle"
  end

  def self.handles?(number)
    number == 1
  end

  def pronoun
    "it"
  end
end

class BottleNumber0 < BottleNumber
  BottleNumber.register(self)

  def self.handles?(number)
    number == 0
  end
  def quantity
    "no more"
  end

  def successor
    BottleNumber.for(99)
  end

  def action
    "Go to the store and buy some more"
  end

end

class BottleNumber6 < BottleNumber
  BottleNumber.register(self)

  def self.handles?(number)
    number == 6
  end

  def quantity
    "1"
  end

  def container
    "six-pack"
  end
end
