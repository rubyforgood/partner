shared_examples_for "user is not logged in" do
  it "returns a 302 redirect" do
    subject
    expect(response).to have_http_status(302)
  end
end
