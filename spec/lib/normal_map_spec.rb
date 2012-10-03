require 'spec_helper'

describe NormalMap do
  let(:filename) { fixture_path 'in.png' }
  let(:options) { {} }
  subject { NormalMap.new filename, options }

  shared_examples_for "expected result" do
    it "should produce expected result" do
      subject.to_blob { self.format = 'PNG' }.should == expected_result
    end
  end

  describe "with no options" do
    let(:expected_result) { fixture 'out_defaults.png' }
    it_should_behave_like "expected result"
  end

  describe "with --smooth" do
    let(:options) { { smooth: true } }
    let(:expected_result) { fixture 'out_smooth.png' }
    it_should_behave_like "expected result"
  end

  describe "with --diagonal" do
    let(:options) { { diagonal: true } }
    let(:expected_result) { fixture 'out_diagonal.png' }
    it_should_behave_like "expected result"
  end

  describe "with --wrap" do
    let(:options) { { wrap: true } }
    let(:expected_result) { fixture 'out_wrap.png' }
    it_should_behave_like "expected result"
  end
end
