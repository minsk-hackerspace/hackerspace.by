require 'ipaddress'
require 'open3'

class WgConfig < ApplicationRecord

  belongs_to :user

  validates :name, presence: true
  validates :privatekey, presence: true
  validates :publickey, presence: true
  validates :name, uniqueness: { scope: :user_id }

  after_initialize :init_keys

  def generate_keys!
    self.privatekey = gen_privatekey
    self.publickey = gen_publickey(self.privatekey)
  end

  def addresses(as_networks=true)
    raise "Model is not saved" if self.id.nil?

    first = IPAddress Setting['wgFirstClientAddress']
    last = IPAddress Setting['wgLastClientAddress']

    ip = IPAddress(first.to_i + self.id)

    raise "Failed to assign IP: out of range" if ip > last

    ip.netmask = Setting['wgNetmask'] if as_networks

    ip.to_string
  end

  def to_s
    lines = []
    lines << "# WireGuard config #{name}"
    lines << '[Interface]'
    lines << "PrivateKey = #{privatekey}"
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

  def init_keys
    generate_keys! if self.privatekey.blank?
  end

  def gen_privatekey
    key, status = Open3.capture2("wg genkey")
    key.strip
  end

  def gen_publickey(private_key)
    stdout_str = ''
    Open3.popen2("wg pubkey") do |stdin, stdout, _wait_thr|
      stdin.print(private_key)
      stdin.close
      stdout_str = stdout.gets
    end

    stdout_str.strip
  end
end
