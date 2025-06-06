require 'roda'
Pizza = Struct.new(:flavor)

class App < Roda
  plugin :h
  mystery_guest = Pizza.new('Mozzarella')

  route do |r|
    p r
    p 'ROUTE block'
    r.get 'hello', String do |name|
      "<h1>Hello #{name}!</h1>"
    end
    r.get 'mystery_guest' do
      "The Mystery Gest is: #{h mystery_guest}"
    end

    r.on 'time' do
      "#{Time.now}"
    end
    r.on 'nothing' do
      false
    end

    r.on 'integer' do
      1
    end
    title = 'Sir'

    r.on 'greet' do
      "Hello, #{title}!"
    end

    r.on 'goodbye' do
      "Goodbye, #{title}!"
    end

    r.on 'posts' do
      post_list = {
        1 => 'Post[1]',
        2 => 'Post[2]',
        3 => 'Post[3]',
        4 => 'Post[4]',
        5 => 'Post[5]'
      }

      r.is Integer do |id|
        post_list[id]
      end

      r.is do
        post_list.values.map { |post| post }.join(' | ')
      end
    end
  end
end
