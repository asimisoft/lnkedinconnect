class PostAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    true
  end

  def creatable_by?(user)
    user.is_admin?
  end

  def updatable_by?(user)
    user.is_admin?
  end

  def deletable_by?(user)
    user.is_admin?
  end
end