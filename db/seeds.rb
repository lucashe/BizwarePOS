# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(:email => 'admin@example.com', :username => 'admin', :password => 'password', :password_confirmation => 'password', :can_update_users => true, :can_update_items => true,
              :can_update_configuration => true, :can_view_reports => true, :can_update_sale_discount => true, :can_remove_sales => true, :role => 'superadmin')

