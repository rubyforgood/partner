FactoryBot.define do
  factory :partner do
    name { "Partner" }
    sequence(:email) { |n| "partner#{n}@email.com" }
    password { "password" }
    address1 { Faker::Address.street_address }

    after(:create) do |partner|
      partner.diaper_partner_id = partner.id
      partner.diaper_bank_id = partner.id
      partner.save!
    end

    trait(:approved) do
      partner_status { "approved" }
    end

    trait(:with_990_attached) do
      proof_of_form_990 { fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "f990.pdf"), "application/pdf") }
    end

    trait(:with_status_proof) do
      proof_of_partner_status { fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "status_proof.pdf"), "application/pdf") }
    end

    trait(:with_other_documents) do
      documents do
        [
          fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "document1.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "document2.pdf"), "application/pdf")
        ]
      end
    end
  end
end
