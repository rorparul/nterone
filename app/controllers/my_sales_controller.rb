class MySalesController < ApplicationController
  def overview

  end

  def queue

  end

  def announcements
    @announcements = Announcement.where(poster: 'Sales Manager').order('created_at DESC')
  end

  def settings
    @user = current_user
  end
end
