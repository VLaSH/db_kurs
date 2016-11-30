module ApplicationHelper
  SORT = { asc: :desc, desc: :asc }.stringify_keys

  def sort_direction
    params[:sort].present? ? SORT[params[:sort]] : :asc
  end
end
