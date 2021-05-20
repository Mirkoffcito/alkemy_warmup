## API TIPO BLOG, CON AUTENTICACIÓN Y SOFT DELETE IMPLEMENTADO

### Enunciado ejercicio:
* Basicamente, debe diseñarse una API tipo blog, que consista de usuarios (pueden crear una cuenta y loguearse), quienes disponen de un CRUD de "Posteos". Para hacer uso del blog, los usuarios deberan autenticarse vía token. Para ésto utilicé la gema devise_auth_token.
* En cuanto a los **posts**, cada post pertenece a un usuario determinado (relación one-to-many) y a una categoría determinada(relación one-to-many). A su vez, cada **categoría** y cada **usuario** pueden tener varios posteos. Las categorías no pertenecen a ningún usuario, ya que pueden ser utilizadas/creadas por cualquier usuario.
* El soft delete reemplaza en su totalidad al destroy en los posteos. Ésto significa que al realizar un DELETE en un posteo, éste no es destruído de la base de datos, sino que es "soft deleted"(utilizando la gema discard) permaneciendo en la base de datos con un método de discarded, conservando la fecha y hora a la que fue descartado.

![warmup](https://user-images.githubusercontent.com/81385234/119032419-8a2ca200-b982-11eb-9782-9cecfba7dd8d.jpg)


### Gemas utilizadas en éste proyecto:

* gem "devise_token_auth", "~> 1.1" **Gema de autenticacion**

* gem "active_model_serializers", "~> 0.10.12" **Serializador**

* gem "has_scope", "~> 0.8.0" **Gema para filtros de busqueda**

* gem "discard", "~> 1.2" **Gema para soft_delete**

* gem "shoulda-matchers", "~> 4.5" **Facilita el testeo con RSpec**

* gem "simplecov", "~> 0.21.2" **Gema para visualizar la cantidad de código testeado**

* gem "database_cleaner-active_record", "~> 2.0" **Gema utilizada para limpiar la base de datos antes de realizar testeos unitarios**

* gem "faker", "~> 2.18" **Gema Faker, utilizada para automatizar la carga de información en la base de datos de testeos**

* gem "factory_bot_rails", "~> 6.2" **Factory bot, utilizada para generar los registros en la base de datos de testeos**

* gem "rspec-rails", "~> 5.0" **Gema utilizada para los testeos de código**

### Pruebas y ENDPOINTS de la API.

