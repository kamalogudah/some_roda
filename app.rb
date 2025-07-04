require 'roda'
Pizza = Struct.new(:flavor)

class App < Roda
  class RodaRequest
    def with_params(hash, &block)
      return unless hash <= params

      on(&block)
    end
  end
  plugin :h
  plugin :all_verbs
  mystery_guest = Pizza.new('Mozzarella')

  route do |r|
    p [0, r.matched_path, r.remaining_path]

    r.root do
      'Root Path'
    end
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

    r.with_params 'secret' => "Um9kYQ==\n" do
    end

    %w[about contact_us license].each do |route_name|
      r.get(route_name) { view(route_name) }
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

      posts = (0..50).map { |i| "Post #{i}" }

      r.is do
        p [3, r.matched_path, r.remaining_path]
        post_list.values.map { |post| post }.join(' | ')
      end

      r.get true do
        posts.join(' | ')
      end

      # r.get Integer do |id|
      #   posts[id]
      # end

      r.get Integer do |id|
        unless post == posts[id]
          response.status = 404
          next 'No matching post'
        end
        access_time = Time.now.strftime('%H:%M')
        "Post: #{post} | Accessing at #{access_time}"
      end

      r.on Integer do |id|
        r.head do
          # Handle HEAD /posts/$ID
        end

        r.get do
          # Handle GET /posts/$ID
        end

        r.post do
          # Handle POST /posts/$ID
        end

        r.put do
          # Handle PUT /posts/$ID
        end

        r.patch do
          # Handle PATCH /posts/$ID
        end
        r.delete do
          # Handle DELETE /posts/$ID
        end
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
