require 'spec_helper'
describe 'nagiosxi' do
  context 'with default values for all parameters' do
    it { should contain_class('nagiosxi') }
  end
end
