module SessionCounter
# This code meets the requirements for a chapter playtime;
# it is not integral to the app
  private

    def increment_count
      session[:counter] ||= 0
      session[:counter] += 1
      if session[:counter] > 5
        return session[:counter]
      end
    end

end
