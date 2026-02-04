class CommentsController < ApplicationController
  def create
    @relationship = Relationship.find(params[:relationship_id])
  end
end