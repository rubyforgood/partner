describe RecertificationMailer, type: :mailer do
  describe "notice_email" do
    let!(:partner) { create(:partner) }
    let!(:user) { create(:user, partner: partner) }
    let!(:mail) { RecertificationMailer.notice_email(user).deliver_now }

    it "email renders the subject" do
      expect(mail.subject).to eq("Please Update Your Agency Information")
    end

    it "email renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "email renders the sender email" do
      expect(mail.from).to eq(["info@diaper.app"])
    end

    it "email assigns @recertification_url" do
      expect(mail.body.encoded)
        .to match('https://partner.diaper.app/')
    end
  end
end

