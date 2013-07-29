require "test_helper"

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @<%= singular_table_name %> = FactoryGirl.create(:<%= table_name.singularize %>)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('<%= class_name %>.count') do
      post :create, <%= "#{singular_table_name}: " %> factory_attributes_with_associations_for(:<%= table_name.singularize %>)
    end

    assert_redirected_to <%= singular_table_name %>_path(assigns(:<%= singular_table_name %>))
  end
  
  def test_create_failed
    assert_difference('<%= class_name %>.count',0) do
      post :create, <%= "#{singular_table_name}: " %> factory_attributes_with_associations_for(:<%= table_name.singularize %>).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, <%= key_value :id, "@#{singular_table_name}" %>
    assert_response :success
  end

  def test_edit
    get :edit, <%= key_value :id, "@#{singular_table_name}" %>
    assert_response :success
  end

  def test_update
    put :update, <%= key_value :id, "@#{singular_table_name}" %>, <%= "#{singular_table_name}: FactoryGirl.attributes_for(:#{table_name.singularize})" %>
    assert_redirected_to <%= singular_table_name %>_path(assigns(:<%= singular_table_name %>))
  end
  
   def test_update_failed
    put :update, <%= key_value :id, "@#{singular_table_name}" %>, <%= "#{singular_table_name}: FactoryGirl.attributes_for(:#{table_name.singularize}).merge()" %> # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, <%= key_value :id, "@#{singular_table_name}" %>
    end

    assert_redirected_to <%= index_helper %>_path
  end
end
<% end -%>
