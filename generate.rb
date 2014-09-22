def lazy(&block)
  Enumerator.new do |yielder|
    loop { yielder.yield block.call }
  end
end

class MoreOrLessThan
  def initialize(value, delta, more)
    @val = value
    @delta = delta
    @more = more
  end
  
  def generate
    <<-CODE
      <div class='more-or-less'>
        #{@delta} #{@more ? 'more' : 'less'} than #{@val}</span> = <span class='answer'></span>
      </div>
    CODE
  end
  
  def self.sequence(deltas, min, max)
    lazy { MoreOrLessThan.new(rand(min..max), deltas.sample, rand > 0.5) }
  end
end

class AddSub
  def initialize(top, bottom, op)
    @top, @bottom, @op = top, bottom, op
  end
  
  def generate
    <<-CODE
      <div class='add-sub'>
        <div class='top'>#{@top}</div>
        <div class='op'>#{@op}</div>
        <div class='bottom'>#{@bottom}</div>
        <div class='answer'>&nbsp;</div>
      </div>
    CODE
  end
  
  def self.sequence(min, max)
    lazy do
      if rand > 0.5
        AddSub.new(rand(min..max), rand(min..max), '+')
      else
        top = rand(min..max)
        bottom = rand(min..top)
        AddSub.new(top, bottom, '-')
      end
    end
  end
end

plan = MoreOrLessThan.sequence([1, 10, 100, 1000], 1000, 9999).first(10) \
        + AddSub.sequence(100, 9000).first(20)

puts File.read('tpl/_header.html') + plan.map(&:generate).join("\n") + File.read('tpl/_footer.html')
