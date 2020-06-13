require "csv"
class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = current_partner.children.includes(:family)

    if filter_params[:child_name_includes].present?
      # Utilize `concat_ws` to combine the two fields and query by ILIKE on it.
      @children = @children.where("concat_ws(' ', first_name, last_name) ILIKE ?", "%#{filter_params[:child_name_includes]}%")
    end

    if filter_params[:guardian_name_includes].present?
      @children = @children.where("concat_ws(' ', families.guardian_first_name, families.guardian_last_name) ILIKE ?", "%#{filter_params[:guardian_name_includes]}%")
    end

    @children = @children.order(last_name: :asc)

    respond_to do |format|
      format.html
      format.csv do
        render(csv: @children.map(&:to_csv))
      end
    end
  end

  def show
    @child = current_partner.children.find_by(id: params[:id])
    @child_item_requests = @child
                           .child_item_requests
                           .includes(:item_request)
  end

  def new
    @child = family.children.new
  end

  def active
    child = current_partner.children.find(params[:child_id])
    child.active = !child.active
    child.save
  end

  def edit
    @child = current_partner.children.find_by(id: params[:id])
  end

  def create
    child = family.children.new(child_params)

    if child.save
      redirect_to child, notice: "Child was successfully created."
    else
      render :new
    end
  end

  def update
    child = current_partner.children.find_by(id: params[:id])

    if child.update(child_params)
      redirect_to child, notice: "Child was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    child = current_partner.children.find_by(id: params[:id])
    if child.present?
      child.destroy
      redirect_to children_url, notice: "Child was successfully destroyed."
    end
  end

  private

  def family
    @_family ||= current_partner.families.find_by(id: params[:family_id])
  end

  def child_params
    params.require(:child).permit(
      :active,
      :agency_child_id,
      :comments,
      :date_of_birth,
      :first_name,
      :gender,
      :health_insurance,
      :item_needed_diaperid,
      :last_name,
      :race,
      :archived,
      child_lives_with: []
    )
  end

  def filter_params
    return {} unless params.key?(:filters)

    params.require(:filters).permit(:guardian_name_includes, :child_name_includes)
  end
end
