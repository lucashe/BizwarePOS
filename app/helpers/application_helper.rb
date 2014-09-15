module ApplicationHelper
  def get_http(url)
    unless url.blank? || url.starts_with?("http://") || url.starts_with?("https://")
      url = "http://" + url
    end
    url
  end

  def role_name(role)

    role_name = "Unknown"

    if role == "superadmin"
      role_name= "superadmin"
    elsif role == "storeadmin"
      role_name= "Store Manager"
    elsif role == "branchadmin"
      role_name= "Branch Manager"
    elsif role == "staff"
      role_name= "Staff"
    end

  end

end
