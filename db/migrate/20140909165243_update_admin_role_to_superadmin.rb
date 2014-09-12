class UpdateAdminRoleToSuperadmin < ActiveRecord::Migration
  
  def self.up
	   update("update users set role = 'superadmin' where id = 1")
  end
end
