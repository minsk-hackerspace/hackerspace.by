class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    # user ||= User.new # guest user (not logged in)
    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    alias_action :create, :read, :update, :destroy, :to => :crud

    # MainController is not REST conroller
    can :manage, :main
    cannot :chart, :main

    can [:show, :index, :create, :new], Thank
    can :read, Project
    can :read, News
    can :read, Tariff

    cannot :image, :uploader

    # device events use its own authorization, skip devise
    can :add, Event

    # for bepaid notifications
    can [:create, :bepaid_notify], EripTransaction
    # double previous line until fully understanding how cancancan works
    can [:create, :bepaid_notify], :erip_transaction

    if user.present?
      can :chart, :main
      can :image, :uploader
      can [:show, :index], User
      can [:update, :edit, :add_mac, :remove_mac, :add_nfc, :remove_nfc], User, id: user.id
      can :manage, Mac, user_id: user.id
      can :manage, NfcKey, user_id: user.id

      can :read, Device
      can :add, Event

      can :create, Project
      can [:update, :destroy], Project do |p|
        p.user_id == user.id or p.public?
      end

      can [:update, :edit, :destroy], News do |news|
        news.user_id == user.id or news.public?
      end

      if user.device?
        can [:find_by_mac, :detected_at_hackerspace], User
      end

      if user.admin?
        can :manage, :all
      end
    end
    cannot :manage, NfcKey

  end
end
