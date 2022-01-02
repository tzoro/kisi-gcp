class PublicController < ApplicationController
  def index
    FetchAddsJob.perform_later
    FetchAddsJob.perform_later
    FetchAddsJob.perform_later
    FetchAddsJob.perform_later
  end
end
