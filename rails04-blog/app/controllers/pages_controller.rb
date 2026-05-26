class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[about privacy]

  def about
    # Intentionally left blank — simple static page
  end

  def privacy
    # Renders privacy policy view
  end
end
