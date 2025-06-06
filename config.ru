require 'roda'

class App < Roda
  route do |r|
    r.get 'hello', String do |name|
      "<h1>Hello #{name}!</h1>"
    end
  end
end

run App
