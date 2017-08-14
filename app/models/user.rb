class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :authorizations
  has_one :profile

  # include Authority::UserAbilities
 

  def is_admin?
    self.role == "admin"
  end

  def self.from_omniauth(auth, current_user)
      p "***************"
      p auth + "~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!~~~~~~~~~~~!!!!!!!!!!"
      p "-------------------------------"

      p "***************"
      p auth.provider
      p "-------------------------------"
      p current_user
      p "******************"
      # if auth.provider == "linkedin"
      #   authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
      # else
        authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s).first_or_initialize
      # end

      p "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~``"
      p authorization
      p "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~``"
      if authorization.user.blank?
        user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
        if user.blank?
          user = User.new
          user.password = Devise.friendly_token[0,10]
          user.first_name = auth.info.name
          p "....................................."
           p user.first_name
          p "....................................."

          if auth.info.email.present?
            user.email = auth.info.email
          else
            user.email = "#{self.name}_email@example.com"
          end
          
          p "....................................."
           p user.email
          p "....................................."
          user.confirmation_token = nil
          user.confirmed_at = Time.now
          p "....................................."
           p auth.provider
          p "....................................."
          auth.provider == "twitter" ? user.save!(:validate => false) : user.save
          #UserMailer.welcome_email()
        end
        authorization.user_id = user.id

        #update the auth keys
        authorization.token = auth.credentials.token
        authorization.secret = auth.credentials.secret

        authorization.save!
      end

      p ":::::::::::::::::::::::::::::::::::::::::::"    
      if auth.provider == "linkedin"  
       authorization.user.create_profile(authorization) if authorization.user.profile.blank?
      else
        p "------->>>>>>>>>>>------------------>>>>>>>>>>>>>>>>>>>"
      end
      authorization.user
    end    


    def create_profile(authorization)
      p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1"
        client = get_linked_client
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!2"
        p client
        p "!!!!!!!!!!!!!!!!!!!!!!3"
        str = ""
        client.authorize_from_access(authorization.token, authorization.secret)
        response = client.profile(:fields=>["first_name","last_name","headline","positions","educations","phone-numbers","email-address","location","picture-url","summary","skills"])
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        p response
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        
        
        #    if response["phone-numbers"].present?
        #      phone = response["phone-numbers"].blank? ? "" : response["phone-numbers"]["all"].first["phone_number"]
        #    end
          
        if response["skills"].present?
          response["skills"]["all"].each do |skill|
            str+=skill["skill"]["name"]+","
          end
        end
        
        
        location = response["location"]["name"].split(",")
        
        country = location[1].present? ?location[1].split(" ") : nil
        
        self.update(:location => location[1].present? ? location[0] : nil,:country => country.present? ? country[0] : location[0],:first_name => response["first_name"],:last_name=>response["last_name"])
        
        pic_response = client.picture_urls(:id=>authorization.uid)
        
       
          
        profile = Profile.create(:user_id=>self.id,:first_name=>response["first_name"],:last_name=>response["last_name"],:filepicker_url=> pic_response["all"].present? ? pic_response["all"].first : "",:location=>location[1].present? ? location[0] : nil,:country => country.present? ?country[0] : location[0],:email=>response["email-address"],:summary=>response["summary"])
        
        
          

        if response["educations"]["all"].present?
          response["educations"]["all"].reverse.each do |education|
            education = profile.educations.new(:college=> education["school_name"].present? ? education["school_name"] : nil,:degree=>education["degree"].present? ? education["degree"] : nil,:field=>education["field_of_study"].present? ? education["field_of_study"] : nil,:graduation_year=>education["end_date"].present? ? education["end_date"]["year"] : nil)
            education.save
          end
        end

        response["positions"]["all"].reverse.each do |emp|
            
          if emp["end_date"].present?
            end_date = !emp["end_date"].blank? ? "01/"+emp["end_date"]["month"].to_s+"/"+emp["end_date"]["year"].to_s : ""
          end
          
          if emp["start_date"].present?
            start_date = "01/"+emp["start_date"]["month"].to_s+"/"+emp["start_date"]["year"].to_s
          end
          
          
          employment = profile.employments.new(:company=>emp["company"]["name"],:position=>emp["title"], :description=>emp["summary"],:start_date=> start_date,:end_date=> end_date,:current=>emp["is_current"])
          employment.save
        end

      end

      def get_linked_client
         client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
      end

end

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :linkedin, "78mzj2fxt8zo48", "bYcrXLfAikhqXDPH"
# end