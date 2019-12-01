require 'net/http'

class TeachersController < ApplicationController
    def create
        @teacher = Teacher.new teacher_params

        # Getting the long and lat of the city they put
        if teacher_params[:city] and teacher_params[:state]
            google_key = "AIzaSyC7jyOFHSorVb256ZEwvvyprp2KPjxKTPw"
            location = teacher_params[:city] + " " + teacher_params[:state]
            location.sub! " ", "+"
            url = "https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=%s" % [location, google_key]
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
            req = Net::HTTP::Get.new(uri.request_uri)
            res = http.request(req)
            data = JSON.parse(res.body)
            teacher_params["lat"] = data["results"][0]["geometry"]["location"]["lat"]
            teacher_params["lng"] = data["results"][0]["geometry"]["location"]["lng"]
        end

        if @teacher.save
            flash[:saved_teacher] = true
            TeacherMailer.welcome_email(@teacher).deliver_now
            
            redirect_to root_path
        else
            redirect_to root_path, alert: "Failed to submit information :("
        end

    end

    private

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap)
        end
end