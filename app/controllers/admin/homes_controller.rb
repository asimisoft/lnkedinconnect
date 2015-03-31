class Admin::HomesController < ApplicationController
  before_filter :is_login?
  def index

  end
end