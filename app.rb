require 'roda'
Pizza = Struct.new(:flavor)

class App < Roda
  plugin :h
  mystery_guest = Pizza.new('Mozzarella')

  route do |r|
    p r
    r.get 'hello', String do |name|
      "<h1>Hello #{name}!</h1>"
    end
    r.get 'mystery_guest' do
      "The Mystery Gest is: #{h mystery_guest}"
    end

    r.on 'time' do
      "#{Time.now}"
    end
  end
end
