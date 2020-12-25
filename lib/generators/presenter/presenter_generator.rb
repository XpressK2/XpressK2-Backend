# frozen_string_literal: true

class PresenterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  desc 'Generate acts_as_api model presenter'
  def create_presenter_file
    template 'presenter.rb', File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
  end

  def columns
    return unless model_exists?

    model_columns = class_name.constantize.column_names
    model_columns.map { |c| "t.add :#{c}" }.join("\n      ")
  end

  def add_presenter_to_the_model
    return unless model_exists?

    inject_into_class "app/models/#{file_name}.rb", class_name do
      "  include #{class_name}Presenter\n"
    end
  end

  private

  def model_exists?
    files = Dir[Rails.root + 'app/models/*.rb']
    models = files.map{ |m| File.basename(m, '.rb').camelize }

    models.include?(class_name) && class_name.constantize
  end
end
