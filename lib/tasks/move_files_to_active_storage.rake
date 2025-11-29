desc "Moving files to active storage"
task move_files_to_active_storage: :environment do
  puts "Moving started..."

  ActiveStorage::Attachment.find_each do |attachment|
    name = attachment.name

    source = attachment.record.send(name).path
    dest_dir = File.join(
      "storage",
      attachment.blob.key.first(2),
      attachment.blob.key.first(4).last(2))
    dest = File.join(dest_dir, attachment.blob.key)

    FileUtils.mkdir_p(dest_dir)
    puts "Moving #{source} to #{dest}"
    FileUtils.cp(source, dest)
  end
end

