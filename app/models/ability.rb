# frozen_string_literal: true

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

    alias_action :create, :read, :update, :destroy, to: :crud

    # MainController is not REST conroller
    can :manage, :main
    cannot :chart, :main

    can %i[show index create new], Thank
    can :read, Project
    can :read, News
    can :read, Tariff

    cannot :image, :uploader

    # device events use its own authorization, skip devise
    can :add, Event

    # for bepaid notifications
    can %i[create bepaid_notify], EripTransaction
    # double previous line until fully understanding how cancancan works
    can %i[create bepaid_notify], :erip_transaction

    can %i[ssh_keys detected_at_hackerspace find_by_mac useful], User

    if user.present?
      can :chart, :main
      can :image, :uploader
      can %i[show index profile], User
      can %i[update edit add_mac remove_mac add_nfc remove_nfc], User, id: user.id
      can :manage, Mac, user_id: user.id
      can :manage, NfcKey, user_id: user.id
      can :manage, PublicSshKey, user_id: user.id

      can :read, Device
      can :add, Event

      can :create, Project
      can [:update, :destroy], Project do |p|
        p.user_id == user.id or p.public?
      end

      can [:update, :edit, :destroy], News do |news|
        news.user_id == user.id or news.public?
      end

      can %i[find_by_mac detected_at_hackerspace], User if user.device?

      can :manage, :all if user.admin?
    end
    cannot :manage, NfcKey
  end
end
