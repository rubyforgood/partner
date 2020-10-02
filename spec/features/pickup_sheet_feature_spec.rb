require "rails_helper"

describe "PickupSheet", type: :feature, include_shared: true, js: true do
  include ActionView::Helpers::SanitizeHelper

  let(:partner) { create(:partner, :verified, id: 3) }
  let(:user) { create(:user, partner: partner) }
  let(:family) { create(:family, partner: partner) }
  let(:another_family) { create(:family, partner: partner) }
  let!(:children) do
    [
      create(:child, family: family),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: another_family, item_needed_diaperid: 2),
      create(:child, family: another_family)
    ].sort_by(&:display_name)
  end
  let!(:child) { children.first }
  let!(:authorized_family_members) do
    [family, another_family].each_with_object({}) do |family, map|
      map[family.id] = Array.new(2).map do
        create(
          :authorized_family_member,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          family: family
        ).display_name
      end
    end
  end

  before do
    Flipper[:family_requests].enable(partner)
    sign_in(user)
  end

  scenario "partner can view and edit a pickup sheet" do
    create_pickup_sheet
    verify_correct_table_headers_are_present
    verify_first_column_displays_child_name
    verify_authorized_members_are_part_of_dropdown_options
    verify_correct_ordered_quantity_is_displayed
    change_picked_up_quantity_and_verify_flash_message
    change_authorized_family_member_and_verify_flash_message
    change_item_picked_up_and_verify_flash_message
    mark_item_as_picked_up_and_verify_flash_message
    mark_item_as_not_picked_up_and_verify_flash_message
  end

  def create_pickup_sheet
    stub_successful_items_partner_request
    stub_successful_family_request
    visit partner_requests_path
    find_link("Create New Family Essentials Request").click
    find('input[type="submit"]').click
    expect(page).to have_text("Request History")
  end

  def verify_correct_table_headers_are_present
    partner_request_id = PartnerRequest.last.id
    visit family_request_pickup_sheets_path(family_request_id: partner_request_id)
    within "thead" do
      expect(find("tr th:nth-child(1)")).to have_text("Child's name")
      expect(find("tr th:nth-child(2)")).to have_text("Authorized Family Member")
      expect(find("tr th:nth-child(3)")).to have_text("Quantity Ordered")
      expect(find("tr th:nth-child(4)")).to have_text("Quantity Picked Up")
      expect(find("tr th:nth-child(5)")).to have_text("Item Ordered")
      expect(find("tr th:nth-child(6)")).to have_text("Item Picked Up")
      expect(find("tr th:nth-child(7)")).to have_text("Picked up")
    end
  end

  def verify_first_column_displays_child_name
    within "tbody" do
      expect(find("tr:nth-child(2) td:nth-child(1)"))
        .to have_text(child.display_name)
    end
  end

  def verify_authorized_members_are_part_of_dropdown_options
    within "tbody" do
      child.family.authorized_family_members.each do |family_member|
        expect(find("tr:nth-child(2) td:nth-child(2)"))
          .to have_text(family_member.display_name)
      end
    end
  end

  def verify_correct_ordered_quantity_is_displayed
    within "tbody" do
      expect(find("tr:nth-child(2) td:nth-child(3)")).to have_text(50)
    end
  end

  def change_picked_up_quantity_and_verify_flash_message
    within "tbody" do
      within find("tr:nth-child(2) td:nth-child(4)") do
        find('input[type="text"]').set("80")
      end
      # random click outside the text input to trigger the ajax request
      find("tr:nth-child(1)").click
    end
    child_item_request = child.child_item_requests.last
    wait_for_flash_message_to_display(child_item_request.id)
    child_item_request.reload
    expected_flash_message = I18n.t(
      "child_item_requests.quantity_picked_up",
      child_name: child.first_name,
      quantity_ordered: child_item_request.quantity,
      quantity_picked_up: child_item_request.quantity_picked_up
    )
    expect(find("td#flash-message-container-nested-#{child_item_request.id}"))
      .to have_text(expected_flash_message)
  end

  def change_authorized_family_member_and_verify_flash_message
    within "tbody" do
      within find("tr:nth-child(2)") do
        select(
          authorized_family_members[child.family.id].last,
          from: "authorized_family_member_id"
        )
      end
    end
    child_item_request = child.child_item_requests.last
    wait_for_flash_message_to_display(child_item_request.id)
    child_item_request.reload
    expected_flash_message = I18n.t(
      "child_item_requests.authorized_family_member_update",
      name: authorized_family_members[child.family.id].last
    )
    expect(find("td#flash-message-container-nested-#{child_item_request.id}"))
      .to have_text(expected_flash_message)
  end

  def change_item_picked_up_and_verify_flash_message
    if child.item_needed_diaperid == 2
      item_picked_up_label = "Magic diaper"
      item_ordered = "Fantastic diaper"
    else
      item_ordered = "Magic diaper"
      item_picked_up_label = "Fantastic diaper"
    end
    within "tbody" do
      within find("tr:nth-child(2)") do
        select(
          item_picked_up_label,
          from: "picked_up_item_diaperid"
        )
      end
    end
    child_item_request = child.child_item_requests.last
    wait_for_flash_message_to_display(child_item_request.id)
    child_item_request.reload
    expected_flash_message = I18n.t(
      "child_item_requests.item_picked_up",
      child_name: child.first_name,
      item_ordered: item_ordered,
      item_picked_up_label: item_picked_up_label
    )
    expect(find("td#flash-message-container-nested-#{child_item_request.id}"))
      .to have_text(expected_flash_message)
  end

  def mark_item_as_picked_up_and_verify_flash_message
    toggle_pickup
    child_item_request = child_item_request_after_flash_message_is_displayed
    expected_flash_message = I18n.t(
      "child_item_requests.pickup.complete",
      child_name: child.first_name
    )
    expect(find("td#flash-message-container-nested-#{child_item_request.id}"))
      .to have_text(expected_flash_message)
  end

  def mark_item_as_not_picked_up_and_verify_flash_message
    toggle_pickup
    child_item_request = child_item_request_after_flash_message_is_displayed
    expected_flash_message = strip_tags(
      I18n.t(
        "child_item_requests.pickup.not_complete",
        child_name: child.first_name
      )
    )
    expect(find("td#flash-message-container-nested-#{child_item_request.id}"))
      .to have_text(expected_flash_message)
  end

  def child_item_request_after_flash_message_is_displayed
    child_item_request = child.child_item_requests.last
    wait_for_flash_message_to_display(child_item_request.id)
    child_item_request.reload
  end

  def toggle_pickup
    within "tbody" do
      within find("tr:nth-child(2)") do
        find("label.custom-control-label").click
      end
    end
  end

  def wait_for_flash_message_to_display(id)
    within find("td#flash-message-container-nested-#{id}") { find("div.alert") }
  end
end
