class TrademarksController < ApplicationController
  def index
    @nice_classes = NiceClass.all
  end
end
