#encoding: UTF-8
class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :short_desc
      t.text :description
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :user_id
      t.boolean :public
      t.string :markup_type

      t.timestamps
    end

    News.create(title: "Мастер-класс \"Бумажная скульптура_pepakura\"",
    short_desc: %( мастер-класс по изготовлению бумажных макетов / моделей / скульптуры/ игрушек сложной криволинейной формы
      процесс: за одно занятие освоим Pepakura Designer — программу для раскройки трёхмерных моделей.
       Склеим из бумаги стильный криволинейный дизайнерский объект. Расширим свои возможности в физическом
      формообразовании минимальными средствами.
                                                                                                                                                                                                                                       для кого_
      для архитекторов, дизайнеров, фанатов косплей и абсолютно всех желающих.
      <br>ведущий:    Мартин Болтовский
      <br>дата: 19 июля, воскресенье),
    description: %(
      <br>что:
      <br>мастер-класс по изготовлению бумажных макетов / моделей / скульптуры/ игрушек сложной криволинейной формы
      <br>процесс:
      <br>за одно занятие освоим Pepakura Designer — программу для раскройки трёхмерных моделей. Склеим из бумаги стильный криволинейный дизайнерский объект. Расширим свои возможности в физическом формообразовании минимальными средствами.
      для кого: для архитекторов, дизайнеров, фанатов косплей и абсолютно всех желающих.
      <br>ведущий: Мартин Болтовский
      <br>дата: 19 июля, воскресенье
      <br>время: 17.00
      <br>место: Минский хакерспейс (Беды, 45)
      <br>http://www.openstreetmap.org/
      <br>вход свободный: при желании можете поддержать проект пожертвованием),
    public: true,
    markup_type: "html")

    News.create(title: "Qodemo",
    short_desc: %(<br>Добро пожаловать на нашу интернациональную 'Openhardware Pizza Party' с командой Qodemo (Амстердам / Бостон)
      <br>Будем рады видеть всех, кто интересуется Open hardware и связанным с ним международным сообществом.
      <br>Языки мероприятия: английский, русский),
    description: %(
      <p>
      We are waiting for special guests
      <br>Эматыкон smile
      <br>
      Welcome to our international 'Openhardware Pizza Party' with Qodemo team (Amsterdam / Boston).
      <br>
      Looking forward to see everyone interested in Open hardware and the international community behind it.
      <br>
      Languages of the event: English, Russian
      </p>
      --------------------------------------------------------
      <p>Ждём специальных гостей
      <br>Эматыкон smile

      <br>Добро пожаловать на нашу интернациональную 'Openhardware Pizza Party' с командой Qodemo (Амстердам / Бостон)

      <br>Будем рады видеть всех, кто интересуется Open hardware и связанным с ним международным сообществом.

      <br>Языки мероприятия: английский, русский</p>),
    markup_type: "html",
    public: true)

  end
end
