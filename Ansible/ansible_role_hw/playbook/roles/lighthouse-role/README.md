Role Name
=========

Роль устанавливает веб-интерфейс [Lighthouse](https://github.com/VKCOM/lighthouse) для ClickHouse, и настраивает nginx для его обслуживания.


Role Variables
--------------

| Переменная              | Описание                                | Значение по умолчанию          |
|-------------------------|-----------------------------------------|---------------------------------|
| `lighthouse_repo`       | Репозиторий Git                         | https://github.com/VKCOM/lighthouse.git |
| `lighthouse_root`       | Куда клонировать репозиторий           | `/opt/lighthouse`              |
| `lighthouse_web_root`   | Веб-корень nginx                        | `/var/www/html`                |


Example Playbook
----------------
    - hosts: servers
      roles:
         - lighthouse-role

License
-------

BSD

Author Information
------------------

Alexey Kapranov