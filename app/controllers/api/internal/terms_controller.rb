class Api::Internal::TermsController < Api::Internal::BaseController
  def index
    respond_with Term.includes(:nice_class).search_by_name(term_search_params[:name])
  end

  private

  def term_search_params
    params.permit(:name)
  end
end
