def search
  @results = Anketum.scoped
  [:width, :height, :any, :other, :searchable, :attribute].each do |key|
    @results.where(key => params[key]) if params[key].present?
  end
end

