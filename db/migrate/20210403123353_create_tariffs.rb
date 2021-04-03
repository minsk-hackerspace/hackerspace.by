class CreateTariffs < ActiveRecord::Migration[6.0]
  def up
    create_table :tariffs do |t|
      t.string :ref_name
      t.string :name
      t.string :description
      t.boolean :access_allowed
      t.decimal :monthly_price

      t.timestamps
    end

    Tariff.create(
      ref_name: 'remote',
      name: 'Remote',
      description: 'Удалённый доступ',
      access_allowed: false,
      monthly_price: 10.0
    )

    Tariff.create(
      ref_name: 'remote+storage',
      name: 'Remote and Storage',
      description: 'Удалённый доступ с хранением коробок',
      access_allowed: false,
      monthly_price: 20.0
    )

    Tariff.create(
      ref_name: 'full',
      name: 'Основной тариф',
      description: 'Полный доступ в хакерспейс',
      access_allowed: true,
      monthly_price: 70.0
    )

    Tariff.create(
      ref_name: 'student',
      name: 'Студенческий',
      description: 'Полный доступ в хакерспейс, для студентов',
      access_allowed: true,
      monthly_price: 20.0
    )
  end

  def down
    drop_table :tariffs
  end
end
