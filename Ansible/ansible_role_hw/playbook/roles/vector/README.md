Role Name
=========

Роль устанавливает [Vector](https://vector.dev) — систему сбора логов, и настраивает её как systemd-сервис.

Role Variables
--------------

| Переменная              | Описание                                      | Значение по умолчанию                               |
|--------------------------|-----------------------------------------------|------------------------------------------------------|
| `vector_version`         | Версия Vector                                 | `"0.35.0"`                                           |
| `vector_install_dir`     | Путь для установки бинарника Vector           | `"/opt/vector"`                                     |
| `vector_config_dir`      | Путь к директории конфигурации Vector         | `"/etc/vector"`                                     |
| `vector_download_url`    | URL архива с бинарником Vector                | Генерируется на основе версии                        |


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - vector-role

License
-------

BSD

Author Information
------------------

Alexey Kapranov