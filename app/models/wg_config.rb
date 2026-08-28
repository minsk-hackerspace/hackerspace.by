require 'ipaddr'
require 'open3'

class WgConfig < ApplicationRecord
  attr_reader :privatekey

  DEFAULT_SETTINGS = {
    'wgServerEndpoint' => {
      description: 'WireGuard server endpoint (in format <IP>:<port>)',
      value: 'localhost:1234'
    },
    'wgServerPublicKey' => {
      description: 'WireGuard server public key',
      value: ''
    },
    'wgFirstClientAddress' => {
      description: 'WireGuard first client address',
      value: '10.129.0.2'
    },
    'wgLastClientAddress' => {
      description: 'WireGuard last client address',
      value: '10.129.255.254'
    },
    'wgNetmask' => {
      description: 'WireGuard netmask for virtual network',
      value: '255.255.0.0'
    },
    'wgAllowedIPs' => {
      description: 'WireGuard AllowedIPs client configuration parameter',
      value: '10.129.0.0/16, 192.168.128.0/24'
    }
  }.freeze

  belongs_to :user

  validates :name, presence: true
  validates :publickey, presence: true
  validates :name, uniqueness: { scope: :user_id }

  before_validation :generate_keys!, on: :create, if: -> { publickey.blank? }

  def self.ensure_default_settings!
    DEFAULT_SETTINGS.each do |key, attributes|
      Setting.find_or_create_by!(key: key) do |setting|
        setting.description = attributes[:description]
        setting.value = attributes[:value]
      end
    end
  end

  def generate_keys!
    @privatekey, self.publickey = gen_keypair
  end

  def addresses(as_networks=true)
    raise "Model is not saved" if self.id.nil?

    first = IPAddr.new(Setting['wgFirstClientAddress'])
    last = IPAddr.new(Setting['wgLastClientAddress'])

    ip = IPAddr.new(first.to_i + self.id, first.family)

    raise "Failed to assign IP: out of range" if ip.to_i > last.to_i

    return ip.to_s unless as_networks

    "#{ip}/#{IPAddr.new(Setting['wgNetmask']).to_i.to_s(2).count('1')}"
  end

  def to_s(private_key = privatekey)
    raise "WireGuard private key is not stored; generate a new client configuration" if private_key.blank?

    lines = []
    lines << "# WireGuard config #{name}"
    lines << '[Interface]'
    lines << "PrivateKey = #{private_key}"
    lines << "Address = #{self.addresses}"
    lines << ''
    lines << '[Peer]'
    lines << "PublicKey = #{Setting['wgServerPublicKey']}"
    lines << "Endpoint = #{Setting['wgServerEndpoint']}"
    lines << "AllowedIPs = #{Setting['wgAllowedIPs']}"

    lines.join("\n")
  end

  def as_peer
    s = []
    s << "# User #{self.user_id}, config '#{self.name}'"
    s << "[Peer]"
    s << "PublicKey = #{publickey}"
    s << "AllowedIPs = #{addresses(false)}"

    s.join("\n")
  end

  private

  def gen_keypair
    output, status = Open3.capture2(Rails.root.join('bin/wg-keypair').to_s)
    raise "Failed to generate WireGuard key pair" unless status.success?

    private_key, public_key = output.lines.map(&:strip)
    raise "Failed to generate WireGuard key pair" if private_key.blank? || public_key.blank?

    [private_key, public_key]
  end
end
