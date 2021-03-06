RSpec.describe PumaCloudwatch::Metrics::Sender do
  subject(:sender) { described_class.new(metrics) }

  context "single mode" do
    context "metrics filled out" do
      let(:metrics) {
        [{:backlog=>[0],
        :running=>[16],
        :pool_capacity=>[8],
        :max_threads=>[16]}]
      }

      it "metric_data" do
        data = sender.metric_data
        expect(data).to eq(
          [{:metric_name=>"backlog",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>1, :sum=>0, :minimum=>0, :maximum=>0}},
           {:metric_name=>"running",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>1, :sum=>16, :minimum=>16, :maximum=>16}},
           {:metric_name=>"pool_capacity",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>1, :sum=>8, :minimum=>8, :maximum=>8}},
           {:metric_name=>"max_threads",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>1, :sum=>16, :minimum=>16, :maximum=>16}}]
        )
      end

      it "call" do
        allow(sender).to receive(:put_metric_data)
        sender.call
        expect(sender).to have_received(:put_metric_data)
      end
    end
  end

  context "cluster mode" do
    context "metrics filled out" do
      let(:metrics) {
        [{:backlog=>[0, 0],
        :running=>[0, 0],
        :pool_capacity=>[16, 16],
        :max_threads=>[16, 16]}]
      }

      it "metric_data" do
        data = sender.metric_data
        expect(data).to eq(
          [{:metric_name=>"backlog",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>2, :sum=>0, :minimum=>0, :maximum=>0}},
           {:metric_name=>"running",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>2, :sum=>0, :minimum=>0, :maximum=>0}},
           {:metric_name=>"pool_capacity",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>2, :sum=>32, :minimum=>16, :maximum=>16}},
           {:metric_name=>"max_threads",
            :dimensions=>[{:name=>"App", :value=>"demo-puma"}],
            :statistic_values=>{:sample_count=>2, :sum=>32, :minimum=>16, :maximum=>16}}]
        )
      end

      it "call" do
        allow(sender).to receive(:put_metric_data)
        sender.call
        expect(sender).to have_received(:put_metric_data)
      end
    end
  end
end
