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
#### A continuación, se hara mención y se explicaran los endpoints válidos de la API, tanto de autenticación cómo del CRUD de posts y categorías.

### ENDPOINTS DE AUTENTICACIÓN
* POST **localhost:3000/api/auth** -> Se utiliza para registrar una nueva cuenta, recibe cómo parametros **email** y **password**
![signup successfull](https://user-images.githubusercontent.com/81385234/119057595-1d75cf80-b9a3-11eb-87ef-61a480e7d689.jpg)

* POST **localhost:3000/api/auth/sign_in** -> Se utiliza para loguearse, recibe cómo parametros un **email** y un **password**, y devuelve en sus headers un **access-token**, **uid** y **client**. Información que utilizaremos para autenticarnos a la hora de hacer úso de la API.
![signin succesful](https://user-images.githubusercontent.com/81385234/119057759-734a7780-b9a3-11eb-9963-682136263cdd.jpg)

* GET **localhost:3000/api/auth/validate_token** -> Se utiliza para verificar la validez de nuestro **token**, recibe cómo parametros en **HEADERS** **access-token, client y uid**
![token validation](https://user-images.githubusercontent.com/81385234/119057983-e18f3a00-b9a3-11eb-979a-d0fc3cb119ab.jpg)

* DELETE **localhost:3000/api/auth/sign_out** -> Realiza el **logout** de la página, es decir, invalida los tokens de acceso actuales. Para volver a hacer úso de la API, deberemos generar un nuevo token vía login.
![successful DELETE LOGOUT](https://user-images.githubusercontent.com/81385234/119058164-392da580-b9a4-11eb-9d68-b9f1a36df34a.jpg)

### ENDPOINTS DE CATEGORIAS
Las categorías son compartidas por todos los usuarios, es decir, cualquier usuario puede crear categorías, y cualquier usuario puede tener accesso/modificar/hacer uso de las categorías que otro usuario ha creado.

* GET **localhost:3000/api/categories** -> Retorna un listado de todas las categorías disponibles para hacer uso
![succesful categories GET](https://user-images.githubusercontent.com/81385234/119058335-9164a780-b9a4-11eb-92af-1848b2b85857.jpg)

* GET **localhost:3000/api/categories/:category_id** -> Retorna una única categoría
![succesful detail category](https://user-images.githubusercontent.com/81385234/119058432-c7099080-b9a4-11eb-92ba-5076bf32a7f3.jpg)

* POST **localhost:3000/api/categories** -> Crea una nueva categoría, recibe cómo parametro "name" (nombre de la categoría)
![categories POST succesful](https://user-images.githubusercontent.com/81385234/119058516-ea344000-b9a4-11eb-91e7-568955aaa532.jpg)

* DELETE **localhost:3000/api/categories/4** -> Borra una categoría existente (Si un post solía ser de dicha categoría, su categoría pasa a ser NIL)
![categories DELETE succesful](https://user-images.githubusercontent.com/81385234/119058682-341d2600-b9a5-11eb-9062-bda58fe49bb0.jpg)

### ENDPOINTS DE POSTS
Los post son individuales de cada usuario, ésto significa que un usuario tendrá acceso de visualización/modificación a unicamente los posts creados por sí mismo. No podrá ver los posts que otro usuario haya creado.
Un aspecto importante de los Posts, es que el campo **imágen** debe ser una URL válida de imágen y debe además existir. Ésto significa que si bien https://imagen.com/image.jpg es sintácticamente válida, si ésta imágen no existe (no devuelve un status 200), la carga será inválida.

* GET **localhost:3000/api/posts** -> Retorna un listado de todos los posts del usuario actualmente autenticado.
![successful GET posts usuario 1](https://user-images.githubusercontent.com/81385234/119059007-db01c200-b9a5-11eb-96ac-8bb65505a028.jpg)
* Mismo GET pero de otro usuario distinto
![succesful GET posts usuario 2](https://user-images.githubusercontent.com/81385234/119059013-ddfcb280-b9a5-11eb-9eda-c534d0a9070d.jpg)

* GET **localhost:3000/api/posts/:post_id** -> Retorna un post en particular del usuario autenticado, si el post no existe o no pertenece al usuario, devolverá un error 404.
![successful GET post detail](https://user-images.githubusercontent.com/81385234/119059242-51062900-b9a6-11eb-95cc-4eb6d3143310.jpg)

* POST **localhost:3000/api/posts** -> Crea un nuevo Post perteneciente al usuario autenticado, recibe cómo parametros **titulo, contenido, imágen, category_id** (category_id débe ser un id válido de una categoría existente) LA URL DE LA IMÁGEN DEBE SER VÁLIDA Y EXISTIR
![successful POST usuario 1](https://user-images.githubusercontent.com/81385234/119059483-c7a32680-b9a6-11eb-8e08-a26f005de394.jpg)

* PUT **localhost:3000/api/posts/:post_id** -> Recibe cómo parámetro uno de los campos de Post y lo modifica por el nuevo valor pasado en el parametro. Se adjunta una imágen del parámetro post[image] siendo enviado, con una URL inválida, a fines de demostrar que sucede cuando recibe una URL inválida.
![PUT invalido con URL invalida de la imagen](https://user-images.githubusercontent.com/81385234/119059629-16e95700-b9a7-11eb-8da0-97086fb1d515.jpg)

* DELETE **localhost:3000/api/posts/:post_id** -> Realiza el **soft_delete** de un post del usuario autenticado. Ésto significa que éste registro sigue guardado en la base de datos, pero que ya no será mostrado al realizar un GET /api/posts
* ![SOFT DELETE post](https://user-images.githubusercontent.com/81385234/119059760-544de480-b9a7-11eb-9c9d-5d88cbbf159e.jpg)
En la imágen observamos cómo el post cuyo id=3 ha sido eliminado. Pero si nos dirigimos a nuestra cónsola en rails, y buscamos ése post en la base de datos, podremos ver que sigue existiendo, sólo que su método "discarded" pasó de ser **false(existir)** a ser **true(soft deleted)**
![post discarded](https://user-images.githubusercontent.com/81385234/119059913-a1ca5180-b9a7-11eb-8cc0-72c39c95870c.jpg)

* Además posee un campo llamado "discarded_at" el cual tiene la fecha en la que el post sufrio el "soft_delete".
![post 3 discarded_at](https://user-images.githubusercontent.com/81385234/119060012-c6bec480-b9a7-11eb-8eee-911f4a00ae47.jpg)

### Por último, podemos ver los filtros que tenemos disponibles para filtrar los resultados que recibimos al realizar un **GET** en api/posts

* Podemos filtrar nuestros posts por **Titulo, categoría ó por título y categoría** y también ordernarlos de manera **ascendente o descendente** (Se encuentran ordenados de manera descendente según fecha de creación por default) de la siguiente manera:

* localhost:3000/api/posts?title=TITULO
* localhost:3000/api/posts?category=CATEGORY_ID
* localhost:3000/api/posts?title=TITULO&category=CATEGORY_ID
* localhost:3000/api/posts?order=ASC
* localhost:3000/api/posts?order=DESC (por default)

#### Adjunto imágenes de los filtros siendo testeados

* Filtrando por título
![filtro title](https://user-images.githubusercontent.com/81385234/119060990-b14a9a00-b9a9-11eb-91d4-9a6255e93e60.jpg)

* Filtrando por Categoría
![filtro category](https://user-images.githubusercontent.com/81385234/119061004-b7407b00-b9a9-11eb-8fbb-c63b900381da.jpg)

* Filtrando por titulo y categoría
![filtro categoria y titulo](https://user-images.githubusercontent.com/81385234/119061026-bf001f80-b9a9-11eb-9d4b-b1681f311d25.jpg)

* Filtrando por orden de creación
![filtro order](https://user-images.githubusercontent.com/81385234/119061050-c9bab480-b9a9-11eb-9981-bb438a000bb0.jpg)





 


