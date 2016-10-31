module SessionsHelper
    def log_in(user)
        #store the user's id in the browser's cache
        session[:user_id] = user.id
    end
    
    def current_user
        if(@current_user.nil?)
            @current_user = User.find_by(id: session[:user_id]) #return
        else
            @current_user #return
        end
    end
    
    def logged_in?
        !current_user.nil?
    end
end
