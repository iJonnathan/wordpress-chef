require 'spec_helper'

describe 'wordpress::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'includes the apache recipe' do
    expect(chef_run).to include_recipe('wordpress::apache')
  end

  it 'includes the php recipe' do
    expect(chef_run).to include_recipe('wordpress::php')
  end

  it 'includes the mysql recipe' do
    expect(chef_run).to include_recipe('wordpress::mysql')
  end

  it 'includes the wordpress recipe' do
    expect(chef_run).to include_recipe('wordpress::wordpress')
  end
end