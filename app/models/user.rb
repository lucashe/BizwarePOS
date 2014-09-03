class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true, :uniqueness => true

  has_many :user_employments
  has_many :store_branches, through: :user_employments
  belongs_to :store

  ROLES = %w[staff branchadmin storeadmin superadmin]
  ROLE_NAMES = %w[Staff Branch_Mgr Store_Mgr superadmin]
  def is?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def role_name
    ROLE_NAMES[ROLES.index(role)]
  end

end
