# frozen_string_literal: true

class V1::BaseController < V1::ApiController
  before_action :set_resource, only: %i[show update destroy]

  ## ------------------------------------------------------------ ##

  # GET : /v2/{resource}
  def index
    data = {
      index_key => collection.as_api_response(index_template, template_injector),
      pagination: pagination(collection)
    }
    yield data if block_given?
    render_success(data: data)
  end

  ## ------------------------------------------------------------ ##

  # GET : /v2/{resource}/:id
  def show
    return render_not_found if get_resource.nil?

    data = { show_key => get_resource.as_api_response(show_template, template_injector) }
    yield data if block_given?
    render_success(data: data)
  end

  ## ------------------------------------------------------------ ##

  # POST : /v2/{resource}/:id
  def create
    set_resource(get_scope.new(params_processed))
    if get_resource.save
      data = { show_key => get_resource.as_api_response(show_template, template_injector) }
      yield data if block_given?
      render_created(data: data, message: created_message)
    else
      render_unprocessable_entity(message: get_resource.errors.full_messages.join(', '))
    end
  end

  ## ------------------------------------------------------------ ##

  # PUT : /v2/{resource}/:id
  def update
    if get_resource.update(params_processed)
      data = { show_key => get_resource.as_api_response(show_template, template_injector) }
      yield data if block_given?
      render_success(data: data, message: updated_message)
    else
      render_unprocessable_entity(message: get_resource.errors.full_messages.join(', '))
    end
  end

  ## ------------------------------------------------------------ ##

  # DELETE : /v2/{resource}/:id
  def destroy
    if get_resource.destroy
      render_success(message: destroyed_message)
    else
      render_unprocessable_entity(message: get_resource.errors.full_messages.join(', '))
    end
  end

  ## ------------------------------------------------------------ ##

  private

  def get_scope
    scope_name = "#{resource_name.pluralize}_scope"
    @scope ||= send(scope_name)
  end

  def set_resource(resource = nil)
    resource ||= get_scope.find(id_parameter)
    instance_variable_set("@#{resource_name}", resource)
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  def resource_name
    @resource_name ||= controller_name.singularize
  end

  def resource_params
    @resource_params ||= \
      if action_name == 'update'
        update_params
      else
        create_params
      end
  end

  def create_params
    send("#{resource_name}_params")
  end
  alias update_params create_params

  def params_processed
    resource_params
  end

  def collection
    @collection ||= build_collection
  end

  def build_collection(scope = nil)
    result = (scope || get_scope)
    result = result.ransack(search_params).result  if search_params.present?
    result = result.page(params[:page]).per(limit) unless skip_pagination?
    result = result.order(collection_order)        if collection_order.present?
    result
  end

  def skip_pagination?
    limit == -1
  end

  def limit
    (params[:limit] || params[:rpp] || 999_999_999).to_i
  end

  def search_params; end

  def collection_order; end

  def default_collection_order
    return 'users.emp_id ASC' unless params[:sort].present?

    params[:sort].keys[0] + ' ' + params[:sort].values[0].upcase
  end

  def id_parameter
    params[:id]
  end

  def employee_id
    @employee_id ||= params[:employee_id]
  end

  def pagination(object)
    {
      current_page: object.try(:current_page) || 1,
      next_page: object.try(:next_page),
      previous_page: object.try(:prev_page),
      total_pages: object.try(:total_pages) || 1,
      per_page: object.try(:limit_value),
      total_entries: object.try(:total_count) || object.count
    }
  end

  def template_injector
    {}
  end

  def index_key
    resource_name.to_s.pluralize.to_sym
  end

  def show_key
    resource_name.to_s.singularize.to_sym
  end

  # the default show template
  def show_template
    :show
  end

  # the default index template
  def index_template
    :index
  end

  def created_message
    I18n.t("#{resource_name}.created")
  end

  def updated_message
    I18n.t("#{resource_name}.updated")
  end

  def destroyed_message
    I18n.t("#{resource_name}.deleted")
  end
end
