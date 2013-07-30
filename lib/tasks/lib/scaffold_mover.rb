class ScaffoldMover

  def self.move_files(sources, destination_path, opts={})
    sources.each do |source_path|
      destination = File.join(*[destination_path, opts[:destination_suffix], source_path].compact)
      source      = File.join(*[Rails.root, opts[:source_prefix], source_path].compact)

      puts "MOVE: #{source} => #{destination}"

      FileUtils.mkdir_p( File.dirname(destination) )
      FileUtils.mv( source, destination) rescue puts($!.inspect.red)


      if opts[:remove_dir]
        puts "DELETE: #{File.dirname(source)}"
        FileUtils.rmdir( File.dirname(source) )
      end
    end

  end

end
