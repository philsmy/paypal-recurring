require "spec_helper"

describe PayPal::Recurring::Response::TransactionSearch do
  let(:paypal) do
    PayPal::Recurring.new({
      :start_date => "2014-01-1T05:38:48Z"
    })
  end

  context "with valid parameters" do
    use_vcr_cassette "transaction_search/valid"
    subject { paypal.transaction_search }

    its(:transactions) { should_not be_empty }
    it { should be_valid }
    it { should be_success }
  end

  context "with parameters that do not return results" do
    use_vcr_cassette "transaction_search/empty"

    before { paypal.start_date = "#{1.year.from_now.year}-01-1T05:38:48Z" }
    subject { paypal.transaction_search }

    its(:transactions) { should be_empty }
    it { should be_valid }
    it { should be_success }
  end

  context "with invalid parameters" do
    use_vcr_cassette "transaction_search/invalid"

    before { paypal.start_date = nil }
    subject { paypal.transaction_search }

    its(:transactions) { should be_empty }
    it { should_not be_valid }
    it { should_not be_success }
  end
end