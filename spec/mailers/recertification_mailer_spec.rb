describe RecertificationMailer, type: :mailer do
  describe "notice_email" do
    let!(:partner) { create(:partner) }
    let!(:user) { create(:user, partner: partner) }
    let!(:mail) { RecertificationMailer.notice_email(user).deliver_now }

    it "email renders the subject" do
      expect(mail.subject).to eq("Please update your agency information")
    end

    it "email renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "email renders the sender email" do
      expect(mail.from).to eq(["partner@diaper-app.org"])
    end

    it "email assigns @recertification_url" do
      expect(mail.body.encoded)
        .to match(edit_partner_url(partner))
    end
  end
end

