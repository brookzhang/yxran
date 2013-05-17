class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)
    
    
    #
    # admin
    #
    if user.has_role? :admin
      #can :manage, :all
    end
    
    
    
    #
    # manager
    #
    if user.has_role? :manager
      
    end
    
    
    
    
    #
    # user
    #
    if user.has_role? :user
      #can :read, [Sale, Expense, Handover, User]
      #can :manage, User, :id => user.id
      #
      #if user.store_id
      #  # on duty  
      #  can :update, Handover, :status => 0, :user_id => user.id
      #  can :manage, Sale, :status => 1, :user_id => user.id, :store_id => user.store_id
      #  can :manage, Expense, :status => 1, :user_id => user.id, :store_id => user.store_id
      #else
      #  can :create, Handover
      #end
      
      
      
    end
    
    
    #
    # stocker
    #
    if user.has_role? :stocker
      
      
    end
    
    
  end
  
  
  
  
end
