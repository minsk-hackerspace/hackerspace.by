class ConvertToActiveStorage < ActiveRecord::Migration[8.1]
  require 'open-uri'

  def up
    adapter_name = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    case adapter_name
    when :mysql, :mysql2
      # mariadb
      get_blob_id = 'LAST_INSERT_ID()'
      connection = ActiveRecord::Base.connection.raw_connection
    when :sqlite
      # sqlite
      get_blob_id = 'LAST_INSERT_ROWID()'
      connection = ActiveRecord::Base.connection.raw_connection
    when :postgresql
      # postgres
      get_blob_id = 'LASTVAL()'
      connection = ActiveRecord::Base.connection
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
    end

    active_storage_blob_statement = <<-SQL
      INSERT INTO active_storage_blobs (
        "key", filename, content_type, metadata, byte_size, checksum, created_at, service_name
      ) VALUES ($1, $2, $3, '{}', $4, $5, $6, $7)
    SQL

    active_storage_attachment_statement =
      "INSERT INTO active_storage_attachments (
        name, record_type, record_id, blob_id, created_at
      ) VALUES ($1, $2, $3, #{get_blob_id}, $4)"

    Rails.application.eager_load!
    models = [News, Project, Thank, User]

    transaction do
      models.each do |model|
        puts model.name

        attachments = model.column_names.map do |c|
          if c =~ /(.+)_file_name$/
            $1
          end
        end.compact

        if attachments.blank?
          next
        end

        model.find_each.each do |instance|
          attachments.each do |attachment|
            if instance.send(attachment).path.blank?
              next
            end
            puts "#{instance.class.name} #{instance.id} #{attachment}"

            if adapter_name == :postgresql
              connection.exec_query(
                active_storage_blob_statement,
                'SQL',
                [
                  key(instance, attachment),
                  instance.send("#{attachment}_file_name"),
                  instance.send("#{attachment}_content_type"),
                  instance.send("#{attachment}_file_size"),
                  checksum(instance.send(attachment)),
                  instance.updated_at.iso8601,
                  'local' # your ActiveStorage service name
                ])

              connection.exec_query(
                active_storage_attachment_statement,
                'SQL',
                [
                  attachment,
                  model.name,
                  instance.id,
                  instance.updated_at.iso8601,
                ])
            else
              connection.execute(
                active_storage_blob_statement,
                [
                  key(instance, attachment),
                  instance.send("#{attachment}_file_name"),
                  instance.send("#{attachment}_content_type"),
                  instance.send("#{attachment}_file_size"),
                  checksum(instance.send(attachment)),
                  instance.updated_at.iso8601,
                  'local' # your ActiveStorage service name
                ])

              connection.execute(
                active_storage_attachment_statement,
                [
                  attachment,
                  model.name,
                  instance.id,
                  instance.updated_at.iso8601,
                ])
            end
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def key(instance, attachment)
    SecureRandom.uuid
    # Alternatively:
    # instance.send("#{attachment}_file_name")
  end

  def checksum(attachment)
    # local files stored on disk:
    url = attachment.path
    Digest::MD5.base64digest(File.read(url))

    # remote files stored on another person's computer:
    # url = attachment.url
    # Digest::MD5.base64digest(Net::HTTP.get(URI(url)))
  end
end
