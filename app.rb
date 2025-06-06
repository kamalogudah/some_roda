require 'roda'
Pizza = Struct.new(:flavor)

class App < Roda
  plugin :h
  mystery_guest = Pizza.new('Mozzarella')

  route do |r|
    p [0, r.matched_path, r.remaining_path]
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
      p [1, r.matched_path, r.remaining_path]
      post_list = {
        1 => 'Post[1]',
        2 => 'Post[2]',
        3 => 'Post[3]',
        4 => 'Post[4]',
        5 => 'Post[5]'
      }

      r.is do
        p [3, r.matched_path, r.remaining_path]
        post_list.values.map { |post| post }.join(' | ')
      end
      r.on Integer do |id|
        post = post_list[id]

        r.on 'show' do
          r.is do
            "Showing #{post}"
          end

          r.is 'detail' do
            "Showing #{post} | Last access: #{Time.now.strftime('%H:%M:%S')}"
          end
        end
      end
    end
  end
end
