# frozen_string_literal: true

class ContentsController < ApplicationController
  before_action :set_content, only: %i[update destroy]

  def index
    # TODO: add pagination
    # Content.all loads all the contents to the memory
    @contents = Content.all
    render json: ContentSerializer.new(@contents), status: :ok
  end

  def create
    content = current_user.contents.new(permitted_params)
    if content.save
      render json: ContentSerializer.new(content), status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @content
      authorize(@content, :update?)

      if @content.update(permitted_params)
        render json: ContentSerializer.new(@content), status: :ok
      else
        render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
      end
    else
      handle_not_found
    end
  end

  def destroy
    if @content
      authorize(@content, :destroy?)

      if @content.destroy
        render json: { message: 'Deleted' }, status: :ok
      else
        render json: { error: @content.errors.full_messages }, status: :unprocessable_entity
      end
    else
      handle_not_found
    end
  end

  private

  def permitted_params
    # better
    # params.require(:content).permit(:title, :body)
    params.permit(:title, :body)
  end

  def set_content
    @content = Content.find_by_id(params[:id])
  end

  def handle_not_found
    render json: { error: 'Content not found' }, status: :not_found
  end
end
