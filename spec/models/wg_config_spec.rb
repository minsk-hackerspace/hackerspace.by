require 'rails_helper'

RSpec.describe WgConfig, type: :model do
  let(:user) { create(:user) }

  before do
    allow(Setting).to receive(:[]).and_call_original
    allow(Setting).to receive(:[]).with('wgFirstClientAddress').and_return('10.129.0.2')
    allow(Setting).to receive(:[]).with('wgLastClientAddress').and_return('10.129.255.254')
    allow(Setting).to receive(:[]).with('wgNetmask').and_return('255.255.0.0')
    allow(Setting).to receive(:[]).with('wgServerPublicKey').and_return('server-public')
    allow(Setting).to receive(:[]).with('wgServerEndpoint').and_return('vpn.example.org:51820')
    allow(Setting).to receive(:[]).with('wgAllowedIPs').and_return('10.129.0.0/16')
  end

  it 'stores only the generated public key' do
    allow(Open3).to receive(:capture2)
      .with(Rails.root.join('bin/wg-keypair').to_s)
      .and_return(["client-private\nclient-public\n", instance_double(Process::Status, success?: true)])

    config = user.wg_configs.create!(name: 'phone')

    expect(config.publickey).to eq('client-public')
    expect(config.privatekey).to eq('client-private')
    expect(config.attributes).not_to have_key('privatekey')
  end

  it 'renders a one-time client config with the generated private key' do
    allow(Open3).to receive(:capture2)
      .with(Rails.root.join('bin/wg-keypair').to_s)
      .and_return(["client-private\nclient-public\n", instance_double(Process::Status, success?: true)])

    config = user.wg_configs.create!(name: 'phone')

    expect(config.to_s).to include('PrivateKey = client-private')
    expect(config.to_s).to include('PublicKey = ')
    expect(config.as_peer).to include('PublicKey = client-public')
  end

  it 'accepts externally generated public keys without calling WireGuard tools' do
    allow(Open3).to receive(:capture2).and_call_original

    config = user.wg_configs.create!(name: 'laptop', publickey: 'client-public')

    expect(Open3).not_to have_received(:capture2)
    expect(config.privatekey).to be_nil
    expect { config.to_s }.to raise_error(RuntimeError, /private key is not stored/)
  end
end
