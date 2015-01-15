module Puppet::Parser::Functions

  newfunction(:map_ip_in_net, :type => :rvalue, :doc => <<-'ENDHEREDOC'
    Maps a an address in to a new network.
    Requires an IP, a network, and prefix lengt:
    $newip = map_ip_in_net( $ip, $net, $prefix )

    ENDHEREDOC
    ) do |args|

    unless args.length == 3 then
      raise Puppet::ParseError, ("map_ip_in_net(): wrong number of arguments (#{args.length}; must be 3)")
    end
    ip = args[0]
    unless ip.respond_to?('to_s') then
      raise Puppet::ParseError, ("#{ip.inspect} is not a string. It looks to be a #{ip.class}")
    end
    ip  = ip.to_s
    net = args[1]
    unless net.respond_to?('to_s') then
      raise Puppet::ParseError, ("#{net.inspect} is not a string. It looks to be a #{net.class}")
    end
    net  = net.to_s
    prefix = args[2]
    unless prefix.respond_to?('to_i') then
      raise Puppet::ParseError, ("#{prefix.inspect} is not a integer. It looks to be a #{prefix.class}")
    end
    prefix  = prefix.to_i

    begin
      ip = IPAddr.new(ip)
      net = IPAddr.new("#{net}/#{prefix}")
      newip= net.mask(prefix) | (ip.to_i - ip.mask(prefix).to_i)
      newip.to_s
    rescue ArgumentError => e
      raise Puppet::ParseError, (e)
    end
  end

end

