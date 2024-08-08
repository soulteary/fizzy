module SplatsHelper
  SPLAT_ROTATION = %w[90 80 75 60 45 35 25 5 -45 -40 -75]
  SPLAT_SIZE = %w[22 18 16 14]

  def splat_rotation(splat)
    "--splat-rotate: #{ SPLAT_ROTATION[Zlib.crc32(splat.to_param) % SPLAT_ROTATION.size] }deg;"
  end

  def splat_size(splat)
    "--splat-size: #{ SPLAT_SIZE[Zlib.crc32(splat.to_param) % SPLAT_SIZE.size] }cqi;"
  end
end
